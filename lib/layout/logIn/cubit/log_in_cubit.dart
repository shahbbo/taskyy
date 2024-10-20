import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskyy/shared/network/remote/dio_helper.dart';
import 'package:taskyy/shared/resources/string_manager.dart';

part 'log_in_state.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit() : super(LogInInitial());

  static LogInCubit get(context) => BlocProvider.of(context);

Future<void> userLogin({
    required String phone,
    required String password,
  }) async {
    emit(LogInLoadingState());
    await DioHelper.postData(
      url: AppStrings.endPointLogin,
      data:
      {
        'phone': phone,
        'password': password,
      },
    ).then((value) {
      emit(LogInSuccessState(value.data));
    }).catchError((onError) {
      if (onError is DioException) {
        debugPrint(onError.response!.data['message']);
        debugPrint(onError.message);
        emit(LogInErrorState(onError.response!.data['message']));
      }
    });
  }
}
