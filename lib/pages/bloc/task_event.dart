
part of 'task_bloc.dart';
abstract class TaskEvent {}

class GetTaskEvent extends TaskEvent {
}

class UpdateTaskEvent extends TaskEvent {
  dynamic id;
  UpdateTaskEvent({required this.id});
}
class AddTaskEvent extends TaskEvent {
}

class DeleteTaskEvent extends TaskEvent {
  dynamic id;
  DeleteTaskEvent({required this.id});
}
class GetTaskFirebaseEvent extends TaskEvent {
}

class UpdateTaskFirebaseEvent extends TaskEvent {
  final int id;
  UpdateTaskFirebaseEvent({required this.id});
}
class AddTaskFirebaseEvent extends TaskEvent {
}

class DeleteTaskFirebaseEvent extends TaskEvent {
  final int id;
  DeleteTaskFirebaseEvent({required this.id});
}