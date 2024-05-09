
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagment/pages/bloc/task_state.dart';
import 'package:taskmanagment/sql_helper/dart/sql_helper.dart';

  part 'task_event.dart';


class TaskManagementBloc extends Bloc<TaskEvent, TaskState> {
  final GlobalKey<ScaffoldState> screenKey = GlobalKey<ScaffoldState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

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
    if(data !=null){
      tasksList=data;
    }
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
    await SQLHelper.createItem(
              titleController.text,
            descriptionController.text,
              dueDateController.text,
             statusController.text);
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
    ScaffoldMessenger.of(screenKey.currentContext!).showSnackBar(
        const SnackBar(content: Text("Successfully Deleted a Task")));
    emit(
      state.updateState(
        isLoading: false,
      ),
    );
    add(GetTaskEvent());
  }


  void clearController(){
    titleController.clear();
    descriptionController.clear();
    statusController.clear();
  }

}
