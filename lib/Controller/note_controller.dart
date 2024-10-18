import 'package:final_exam/Services/firebase_firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Modal/note_modal.dart';
import '../Services/database_services.dart';

class NoteController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController editTitleController = TextEditingController();
  final TextEditingController editContentController = TextEditingController();
  var notes = <Note>[].obs;
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    List<Note> loadedNotes = await dbHelper.getNotes();
    notes.assignAll(loadedNotes);
    update();
  }

  void addNote(String title, String content) async {
    String currentTime = TimeOfDay.now().format(Get.context!);
    Note newNote = Note(
      title: title,
      content: content,
      time: currentTime,
    );
    int id = await dbHelper.insertNote(newNote);
    newNote.id = id;
    notes.add(newNote);
    update();
  }

  void deleteNote(int index) async {
    await dbHelper.deleteNote(notes[index].id!);
    notes.removeAt(index);
    update();
  }

  void editNoteTitle(int index, String newTitle, String newContent) async {
    var note = notes[index];
    note.title = newTitle;
    note.content = newContent;
    await dbHelper.updateNote(note);
    notes[index] = note;
    update();
  }

  void createNewNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Note Title",
              ),
            ),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: contentController,
              decoration: const InputDecoration(
                hintText: "Note Content",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {

              addNote(
                  titleController.text.trim(), contentController.text.trim());

              Navigator.of(context).pop();
              titleController.clear();
              contentController.clear();

            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              titleController.clear();
              contentController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void editNote(BuildContext context, int index) {
    editTitleController.text = notes[index].title;
    editContentController.text = notes[index].content;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          children: [
            TextField(
              controller: editTitleController,
              decoration: const InputDecoration(
                hintText: "Edit Title",
              ),
            ),
            TextField(
              controller: editContentController,
              decoration: const InputDecoration(
                hintText: "Edit Content",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              String updatedTitle = editTitleController.text.trim();
              String updatedContent = editContentController.text.trim();
              if (updatedTitle.isNotEmpty && updatedContent.isNotEmpty) {
                editNoteTitle(index, updatedTitle, updatedContent);
                Navigator.of(context).pop();
                editTitleController.clear();
                editContentController.clear();
              }
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              editTitleController.clear();
              editContentController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void allDataStoreToFireStore() {
    for(Note notesModal in notes)
    {
      FirebaseFirestoreServices.firebaseFirestoreServices.storeAllData(notesModal);
    }
  }
}


