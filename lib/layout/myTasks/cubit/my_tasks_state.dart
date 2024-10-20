part of 'my_tasks_cubit.dart';

@immutable
sealed class MyTasksState {}

final class MyTasksInitial extends MyTasksState {}

final class MyTasksLoadingState extends MyTasksState {}

final class MyTaskSuccessState extends MyTasksState {

  final bool lastPage;
  MyTaskSuccessState({required this.lastPage});
}

final class MyTasksErrorState extends MyTasksState {
  final String message;

  MyTasksErrorState(this.message);
}

final class GetTaskByIdLoading extends MyTasksState {}
final class GetTaskByIdSuccess extends MyTasksState {
  final TaskModel taskModel;

  GetTaskByIdSuccess(this.taskModel);
}
final class GetTaskByIdError extends MyTasksState {
  final String message;

  GetTaskByIdError(this.message);
}
final class RefreshTokenLoading extends MyTasksState {}

final class RefreshTokenSuccess extends MyTasksState {}

final class RefreshTokenError extends MyTasksState {
  final String message;

  RefreshTokenError(this.message);
}

final class LogoutLoading extends MyTasksState {}

final class LogoutSuccess extends MyTasksState {
  final dynamic data;

  LogoutSuccess(this.data);
}

final class LogoutError extends MyTasksState {
  final String message;

  LogoutError(this.message);
}

final class DeleteTaskLoading extends MyTasksState {}

final class DeleteTaskSuccess extends MyTasksState {
  final dynamic data;

  DeleteTaskSuccess(this.data);
}

final class DeleteTaskError extends MyTasksState {
  final String message;

  DeleteTaskError(this.message);
}