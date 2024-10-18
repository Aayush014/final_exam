import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Modal/note_modal.dart';

class FirebaseFirestoreServices {
  static FirebaseFirestoreServices firebaseFirestoreServices =
      FirebaseFirestoreServices._();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseFirestoreServices._();

  void storeAllData(Note note) {
    try {
      CollectionReference users = firestore.collection('notes');
      users.doc(note.id.toString()).set(note.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<QuerySnapshot<Object?>> fetchData() {
    Stream<QuerySnapshot> usersStream =
    firestore.collection('notes').snapshots();
    return usersStream;
    }
}
