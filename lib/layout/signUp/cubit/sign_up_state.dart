part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoadingState extends SignUpState {}

final class SignUpSuccessState extends SignUpState {
  final dynamic data;

  SignUpSuccessState(this.data);
}

final class SignUpErrorState extends SignUpState {
  final String error;

  SignUpErrorState(this.error);
}