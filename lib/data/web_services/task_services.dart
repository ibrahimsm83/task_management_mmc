import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class TaskServices{
  //Singleton class
  TaskServices._();
  static final TaskServices _instance=TaskServices._();

  factory TaskServices(){
    return _instance;
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;


  ///Get Data

    void getDataFromFirebase()async {
      final CollectionReference users = db.collection('tasks');
      final String id = await users.firestore.databaseId;
      print("id----- $id");
      final DocumentSnapshot snapshot = await users.doc(id).get();
      // final userFields = snapshot.data();
      final userFields = snapshot.data() as Map<String, dynamic>;
      // log(userFields['title']);
      // print(userFields['description'].toString());
      log(userFields.toString());
    }

///Add Data
  void addDataInFirebase(DocumentReference<Map<String, dynamic>> docRef, String title,String description,String status)async {
    //final  docRef = db.collection('tasks').doc();
    final Map<String,dynamic> userFields={
      'id':docRef.id,
      'title':title,
      'description':description,
      'status':status
    };
    await docRef.set(userFields).then((value) => log("Tasks Added Successfully!"),
    onError: (e)=>log("Error Task Management: $e")
    );
   //await users.doc('newTask').set(userFields);
  }
  ///Update Data
  void updateDataInFirebase(String title,String description,String status,String id)async {
    final CollectionReference users = db.collection('tasks');
    final Map<String,dynamic> userFields={
      'title':title,
      'description':description,
      'status':status
    };
    await users.doc(id).update(userFields);
  }
  ///Delete Data
  Future<dynamic> deleteDataInFirebase(String id)async {
    final CollectionReference users = db.collection('tasks');
    await users.doc(id).delete();
  }
}