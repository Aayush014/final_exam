import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam/Controller/note_controller.dart';
import 'package:final_exam/Services/firebase_firestore_services.dart';
import 'package:flutter/material.dart';

class FatchScreen extends StatelessWidget {
  const FatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestoreServices.firebaseFirestoreServices.fetchData(),
          builder: (context, snapshot) {
            Stream<QuerySnapshot<Object?>> data = FirebaseFirestoreServices.firebaseFirestoreServices.fetchData();
            if(snapshot.hasData){
              return Text("data");
            }
            else{
              return ListTile(
                title: Text(data.toString()),
              );
            }
          },),
    );
  }
}
