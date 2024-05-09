import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagment/pages/bloc/task_bloc.dart';
import 'package:taskmanagment/pages/bloc/task_state.dart';



class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  late TaskManagementBloc screenBloc;

  @override
  void initState() {
    screenBloc = BlocProvider.of<TaskManagementBloc>(context);
    screenBloc.add(GetTaskEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: screenBloc.screenKey,
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Tasks"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        //tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TaskManagementBloc, TaskState>(
        builder: (context, state) {
          if(state.isLoading){
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
                                  Text(screenBloc.tasksList[index]['description']),
                                  Text(
                                      "Status :${screenBloc.tasksList[index]['status']}"),
                                ]),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () =>
                                      _showForm(screenBloc.tasksList[index]['id']),
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () =>
                                  screenBloc.add(DeleteTaskEvent(id: screenBloc.tasksList[index]['id'])),
                                  icon: Icon(Icons.delete)),
                            ],
                          ),
                        ],
                      ),
                    ));
              });
        },
      ),
    );
  }





  void _showForm(int? id) {
    //for update check id
    if (id != null) {
      final existingTasks = screenBloc.tasksList.firstWhere((e) => e['id'] == id);
      screenBloc.titleController.text = existingTasks['title'];
      screenBloc.descriptionController.text = existingTasks['description'];
      screenBloc.statusController.text = existingTasks['status'];
    }
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
