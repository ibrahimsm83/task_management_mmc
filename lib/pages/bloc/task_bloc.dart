
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagment/data/web_services/task_services.dart';
import 'package:taskmanagment/pages/bloc/task_state.dart';
import 'package:taskmanagment/sql_helper/dart/sql_helper.dart';

  part 'task_event.dart';


class TaskManagementBloc extends Bloc<TaskEvent, TaskState> {
  final GlobalKey<ScaffoldState> screenKey = GlobalKey<ScaffoldState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
            TaskServices taskServices=TaskServices();
  final FirebaseFirestore db = FirebaseFirestore.instance;
   List<Map<String,dynamic>> tasksList=[];

   TaskManagementBloc() : super( TaskInitial()) {


    on<GetTaskEvent>(_onGetTaskEvent);
    on<UpdateTaskEvent>(_onUpdateTaskEvent);
    on<AddTaskEvent>(_onAddTaskEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
  }

  void _onGetTaskEvent(GetTaskEvent event, Emitter emit) async{
    emit(
      state.updateState(
        isLoading: true,
      ),
    );
    final data= await SQLHelper.getTasks();
     //final firebasedata= taskServices.getDataFromFirebase();
    // print("----dfs-fsd-f-sd-f-s");
    // print(firebasedata.toString());
    if(data !=null){
      tasksList=data;
    }
    print("------ddd---------1--");
    print(tasksList);
    print("------ddd--------2---");
    emit(
      state.updateState(
        isLoading: false,
      ),
    );
  }

  void _onUpdateTaskEvent(UpdateTaskEvent event, Emitter emit)async {
    emit(
      state.updateState(
        isLoading: true,
      ),
    );
    await SQLHelper.updateTask(
            event.id,
            titleController.text,
            descriptionController.text,
            dueDateController.text,
            statusController.text);
    taskServices.updateDataInFirebase( titleController.text, descriptionController.text,  statusController.text,event.id);
    emit(
      state.updateState(
        isLoading: false,
      ),
    );
    add(GetTaskEvent());
    clearController();
    emit(
      state.updateState(
        isChangeList: !state.isChangeList,
      ),
    );
  }
  void _onAddTaskEvent(AddTaskEvent event, Emitter emit) async{

    emit(
      state.updateState(
        isLoading: true,
      ),
    );
    final  docRef = db.collection('tasks').doc();
    print(docRef.id);
    await SQLHelper.createItem(
                  docRef.id,
              titleController.text,
            descriptionController.text,
              dueDateController.text,
             statusController.text);
    print("-----------data added successfully------1------");
    taskServices.addDataInFirebase( docRef,titleController.text, descriptionController.text, statusController.text,);
    print("-----------data added successfully----------2--");
    add(GetTaskEvent());
    clearController();
    emit(
      state.updateState(
        isLoading: false,
      ),
    );
  }
  void _onDeleteTaskEvent(DeleteTaskEvent event, Emitter emit) async {
    emit(
      state.updateState(
        isLoading: true,
      ),
    );
    await SQLHelper.deleteTask(event.id);
print("--------_Delete-----------1");
    emit(
      state.updateState(
        isLoading: false,
      ),
    );
    ScaffoldMessenger.of(screenKey.currentContext!).showSnackBar(
        const SnackBar(content: Text("Successfully Deleted a Task")));
    add(GetTaskEvent());
    await taskServices.deleteDataInFirebase(event.id);
    print("--------_Delete-----------2");


  }


  void clearController(){
    titleController.clear();
    descriptionController.clear();
    statusController.clear();
  }

}
