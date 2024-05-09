

import 'package:flutter/material.dart';
import 'package:taskmanagment/sql_helper/dart/sql_helper.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
final TextEditingController _titleController=TextEditingController();
final TextEditingController _descriptionController=TextEditingController();
final TextEditingController _statusController=TextEditingController();
final TextEditingController _dueDateController=TextEditingController();

  List<Map<String,dynamic>> _tasksList=[];

  bool _isLoading=true;

  void _refreshTasks() async{
    final data= await SQLHelper.getTasks();
    setState(() {
      _tasksList =data;
      _isLoading=false;
    });
  }

  @override
  void initState() {
  _refreshTasks();
  print("number of tasks  ${_tasksList.length}");
  super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blueGrey,
   appBar: AppBar(
     backgroundColor: Colors.blue,
     title: Text("Tasks"),
   ),
      floatingActionButton: FloatingActionButton(
        onPressed:()=>_showForm(null),
        //tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: _tasksList.length,
          itemBuilder: (context,index){
          return Card(
            color: Colors.orange,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_tasksList[index]['title']),
                        Text(_tasksList[index]['description']),
                        Text("Status :${_tasksList[index]['status']}"),
                    ]),
                  ),
                  Row(children: [
                    IconButton(onPressed: ()=>_showForm(_tasksList[index]['id']),
                        icon: const Icon(Icons.edit)),
                    IconButton(onPressed: ()=> _deleteTask(_tasksList[index]['id']), icon: Icon(Icons.delete)),
                  ],
                  ),
                ],
              ),
            )
          );
          }
      ),
    );
  }

Future<void> _addTask()async{
    await SQLHelper.createItem(_titleController.text, _descriptionController.text, _dueDateController.text, _statusController.text);
    _refreshTasks();
}
Future<void> _updateTask(int id)async{
  await SQLHelper.updateTask( id,  _titleController.text, _descriptionController.text, _dueDateController.text, _statusController.text);
  _refreshTasks();
}

Future<void> _deleteTask(int id)async{
  await SQLHelper.deleteTask( id);
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Deleted a Task")));
  _refreshTasks();
}

  void _showForm(int? id){
    //for update check id
    if(id!=null){
      final existingTasks=_tasksList.firstWhere((e) => e['id']==id);
      _titleController.text=existingTasks['title'];
      _descriptionController.text=existingTasks['description'];
      _statusController.text=existingTasks['status'];
    }
    showModalBottomSheet(context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_)=>Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            //this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom+120
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 10.0),
              TextField(
           controller: _titleController,
                decoration: InputDecoration(hintText: "Title"),
          ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                           controller: _descriptionController,
                  decoration: InputDecoration(hintText: "Description"),
                          ),
              ),
              TextField(
           controller: _statusController,
                decoration: InputDecoration(hintText: "Status"),
          ),
            const SizedBox(height: 20.0),
              ElevatedButton(onPressed: ()async{
                if(id==null){
                  await _addTask();
                }
                if(id !=null){
                  await _updateTask(id);
                }
                _titleController.text='';
                _descriptionController.text='';
                _statusController.text='';

                Navigator.of(context).pop();

              }, child: Text(id==null?"Create New":'Update'),),
            ],
          ),
        ));
  }
}
