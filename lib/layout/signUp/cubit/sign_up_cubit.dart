import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskyy/shared/network/remote/dio_helper.dart';
import 'package:taskyy/shared/resources/string_manager.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  static SignUpCubit get(context) => BlocProvider.of(context);

  Future<void>signUp({
    required String phone,
    required String password,
    required String displayName,
    required String experienceYears,
    required String address,
    required String level,
  }) async {
    emit(SignUpLoadingState());
    await DioHelper.postData(
      url: AppStrings.endPointSignUp,
      data: {
        'phone': phone,
        'password': password,
        'displayName': displayName,
        'experienceYears': experienceYears,
        'address': address,
        'level': level,
      },
    ).then((value) {
      print(value.data);
      emit(SignUpSuccessState(value.data));
    }).catchError((onError) {
      if (onError is DioException) {
        debugPrint(onError.response!.data['message']);
        debugPrint(onError.message);
        emit(SignUpErrorState(onError.response!.data['message']));
      }
    });
  }
}
