import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskyy/layout/components/constants.dart';
import 'package:taskyy/models/userModel/userModel.dart';
import 'package:taskyy/shared/network/local/cache_helper.dart';
import 'package:taskyy/shared/network/remote/dio_helper.dart';
import 'package:taskyy/shared/resources/string_manager.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  UserModel? profileModel ;
  Future<void> getProfile() async {
    emit(ProfileLoadingState());
    await DioHelper.getDate(
      url: AppStrings.endPointProfile,
    ).then((value) {
      print(value.data);
      profileModel = UserModel.fromJson(value.data);
      emit(ProfileSuccessState(value.data));
    }).catchError((onError) {
      if (onError is DioException) {
        if(onError.response!.statusCode == 401){
          getRefreshToken().then((value) {
            getProfile();
          });
        }
        debugPrint(onError.response!.data['message']);
        debugPrint(onError.message);
        emit(ProfileErrorState(onError.response!.data['message']));
      }
    });
  }

  Future<void> getRefreshToken() async{
    emit(RefreshTokenLoadingState());
    refreshToken = CacheHelper.getData(key: 'refreshToken');
    await DioHelper.getDate(
      url: 'auth/refresh-token?token=$refreshToken',
    ).then((value) {
      CacheHelper.saveData(key: 'TokenId', value: value.data['access_token']);
      emit(RefreshTokenSuccessState());
    }).catchError((onError) {
      if (onError is DioException) {
        debugPrint(onError.response!.statusCode.toString());
        debugPrint(onError.response!.data['message']);
        emit(RefreshTokenErrorState(onError.response!.data['message']));
      }
    });
  }
}
