part of 'get_task_by_id_cubit.dart';

@immutable
sealed class GetTaskByIdState {}

final class GetTaskByIdInitial extends GetTaskByIdState {}

final class GetTaskByIdLoading extends GetTaskByIdState {}

final class GetTaskByIdSuccess extends GetTaskByIdState {
  final dynamic data;

  GetTaskByIdSuccess(this.data);
}

final class GetTaskByIdError extends GetTaskByIdState {
  final String message;

  GetTaskByIdError(this.message);
}