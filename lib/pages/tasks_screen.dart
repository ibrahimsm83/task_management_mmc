

import 'package:flutter/material.dart';
import 'package:taskmanagment/sql_helper/dart/sql_helper.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  List<Map<String,dynamic>> _tasksList=[];
  bool _isLoading=true;
  void _refreshTasks()async{
    final data= await SQLHelper.getTasks();

  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(

    );
  }
}
