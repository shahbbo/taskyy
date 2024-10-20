part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileSuccessState extends ProfileState {
  final dynamic data;

  ProfileSuccessState(this.data);
}

final class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);
}

final class RefreshTokenLoadingState extends ProfileState {}

final class RefreshTokenSuccessState extends ProfileState {}

final class RefreshTokenErrorState extends ProfileState {
  final String message;

  RefreshTokenErrorState(this.message);
}
