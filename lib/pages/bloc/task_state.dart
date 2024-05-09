// part of 'task_bloc.dart';

import 'package:equatable/equatable.dart';

class TaskState extends Equatable {
  final bool isLoading;
  final bool isChangeList;


  const TaskState.empty({
    this.isLoading = false,
    this.isChangeList = false,
  });

  // ignore: unused_element
  const TaskState._({
    required this.isLoading,
    required this.isChangeList,

  });

  TaskState updateState({
    bool? isLoading,
    bool? isChangeList,

  }) {
    return TaskState._(
      isLoading: isLoading ?? this.isLoading,
      isChangeList: isChangeList ?? this.isChangeList,


    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isChangeList,
  ];
}

class TaskInitial extends TaskState {
  const TaskInitial() : super.empty();
}
