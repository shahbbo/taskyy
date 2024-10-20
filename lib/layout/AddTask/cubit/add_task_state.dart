part of 'add_task_cubit.dart';

@immutable
sealed class AddTaskState {}

final class AddTaskInitial extends AddTaskState {}


final class PostImagePickedSuccessState extends AddTaskState {}

final class PostImagePickedErrorState extends AddTaskState {}

final class AddTaskLoading extends AddTaskState {}

final class AddTaskSuccess extends AddTaskState {
}

final class AddTaskError extends AddTaskState {
  final String message;

  AddTaskError(this.message);
}


final class UploadImageLoading extends AddTaskState {}

final class UploadImageSuccess extends AddTaskState {
  final String image;

  UploadImageSuccess(this.image);
}

final class UploadImageError extends AddTaskState {
  final String message;

  UploadImageError(this.message);
}
final class EditTaskLoadingState extends AddTaskState {}
final class EditTaskSuccessState extends AddTaskState {}
final class EditTaskErrorState extends AddTaskState {
  final String message;
  EditTaskErrorState(this.message);
}