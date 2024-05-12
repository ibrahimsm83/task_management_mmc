import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagment/data/web_services/internet/internet_cubit.dart';
import 'package:taskmanagment/pages/bloc/task_bloc.dart';
import 'package:taskmanagment/pages/bloc/task_state.dart';

import '../data/web_services/internet/internet_state.dart';


class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  late TaskManagementBloc screenBloc;
  String fcmToken = "";
  late final InternetCubit internetCubit;

  @override
  void initState() {
    screenBloc = BlocProvider.of<TaskManagementBloc>(context);
    internetCubit = BlocProvider.of<InternetCubit>(context);
    screenBloc.add(GetTaskEvent());
    internetCubit.checkConnectivity();
    internetCubit.trackConnectivityChange();
    firebase();
    super.initState();
  }
  @override
  void dispose() {
    internetCubit.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: screenBloc.screenKey,
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Tasks"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null,null,null,null),
        //tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          screenBloc.add(GetTaskEvent());
        },
        child: BlocBuilder<InternetCubit, InternetStatus>(
          builder: (context, state) {
            return state.status==ConnectivityStatus.connected? _buildList(context):
            BlocBuilder<TaskManagementBloc, TaskState>(
              builder: (context, state)
            {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator(),);
              }
              return ListView.builder(
                  itemCount: screenBloc.tasksList.length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: Colors.orange,
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(screenBloc.tasksList[index]['title']),
                                      Text(screenBloc
                                          .tasksList[index]['description']),
                                      Text(
                                          "Status :${screenBloc
                                              .tasksList[index]['status']}"),
                                    ]),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () =>
                                          _showForm(
                                              screenBloc.tasksList[index]['taskId'],
                                              screenBloc
                                                  .tasksList[index]['title'],
                                              screenBloc
                                                  .tasksList[index]['description'],
                                              screenBloc
                                                  .tasksList[index]['status']),
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () =>
                                          screenBloc.add(DeleteTaskEvent(
                                              id: screenBloc
                                                  .tasksList[index]['taskId'])),
                                      icon: Icon(Icons.delete)),
                                ],
                              ),
                            ],
                          ),
                        ));
                  });
            },
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var document = snapshot.data!.docs[index];
            return Card(
              color: Colors.orange,
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(document['title']),
                            Text(document['description']),
                            Text(document['status']),
                            // Text(screenBloc.tasksList[index]['title']),
                            // Text(screenBloc.tasksList[index]['description']),
                            // Text(
                            //     "Status :${screenBloc.tasksList[index]['status']}"),
                          ]),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () =>
                                _showForm(document['id'],document['title'],document['description'],document['status']),
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () =>
                                screenBloc.add(DeleteTaskEvent(
                                    id: document['id'])),
                            icon: Icon(Icons.delete)),
                      ],
                    ),
                  ],
                ),),);
            //   ListTile(
            //   title: Text(document['title']),
            //   subtitle: Text(document['subtitle']),
            //   // Add more fields as needed
            // );
          },
        );
      },
    );
  }

  void firebase() {
    FirebaseMessaging.instance.getToken().then((value) {
      if (value != null) {
        fcmToken = value;
        log("-----device toekn-----1-${fcmToken.toString()}");
      }
    });
  }


  void _showForm(String? id,String? title,String? description,String? status) {
    //for update check id
    if (id != null) {
      screenBloc.titleController.text=title!;
      screenBloc.descriptionController.text=description!;
      screenBloc.statusController.text=status!;
    }
    //   final existingTasks = screenBloc.tasksList.firstWhere((e) =>
    //   e['id'] == id);
    //   screenBloc.titleController.text = existingTasks['title'];
    //   screenBloc.descriptionController.text = existingTasks['description'];
    //   screenBloc.statusController.text = existingTasks['status'];
    // }
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) =>
            Container(
              padding: EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                  //this will prevent the soft keyboard from covering the text fields
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom + 120),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: screenBloc.titleController,
                    decoration: InputDecoration(hintText: "Title"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextField(
                      controller: screenBloc.descriptionController,
                      decoration: InputDecoration(hintText: "Description"),
                    ),
                  ),
                  TextField(
                    controller: screenBloc.statusController,
                    decoration: InputDecoration(hintText: "Status"),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        screenBloc.add(AddTaskEvent());
                      }
                      if (id != null) {
                        screenBloc.add(UpdateTaskEvent(id: id));
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? "Create New" : 'Update'),
                  ),
                ],
              ),
            ));
  }
}
