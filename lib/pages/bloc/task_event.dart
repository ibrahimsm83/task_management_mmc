
part of 'task_bloc.dart';
abstract class TaskEvent {}

class GetTaskEvent extends TaskEvent {
}

class UpdateTaskEvent extends TaskEvent {
  final int id;
  UpdateTaskEvent({required this.id});
}
class AddTaskEvent extends TaskEvent {

}

class DeleteTaskEvent extends TaskEvent {
  final int id;
  DeleteTaskEvent({required this.id});
}