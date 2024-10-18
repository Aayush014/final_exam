import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/note_controller.dart';
import '../Services/google_auth_services.dart';
import '../Utils/color_palate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    NoteController controller = Get.put(NoteController());
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              GoogleAuthServices.googleAuthServices.currentUser()?.photoURL ??
                  "https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg",
            ),
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                controller.allDataStoreToFireStore();
              },
              icon: Icon(Icons.sync))
        ],
        title: Text(
          "${(GoogleAuthServices.googleAuthServices.currentUser()?.displayName?.split(' ')[0] ?? 'User')}'s Notes",
          style: TextStyle(color: tileColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: GetBuilder<NoteController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.only(top: 15),
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: controller.notes.length,
              itemBuilder: (context, index) {
                final note = controller.notes[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      onLongPress: () {
                        controller.editNote(context, index);
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            note.content,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Created at: ${note.time}",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                      trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          controller.deleteNote(index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          controller.createNewNote(context);
        },
        child: Icon(
          CupertinoIcons.add,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
