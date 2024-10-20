part of 'log_in_cubit.dart';

@immutable
sealed class LogInState {}

final class LogInInitial extends LogInState {}


final class LogInLoadingState extends LogInState {}

final class LogInSuccessState extends LogInState {
  final Map<String, dynamic> data;

  LogInSuccessState(this.data);
}

final class LogInErrorState extends LogInState {
  final String message;

  LogInErrorState(this.message);
}