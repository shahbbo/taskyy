import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskyy/layout/myTasks/cubit/my_tasks_cubit.dart';
import 'package:taskyy/models/taskModels/taskModel.dart';
import 'package:taskyy/shared/network/remote/dio_helper.dart';
import 'package:taskyy/shared/resources/string_manager.dart';

part 'get_task_by_id_state.dart';

class GetTaskByIdCubit extends Cubit<GetTaskByIdState> {
  GetTaskByIdCubit() : super(GetTaskByIdInitial());

  static GetTaskByIdCubit get(context) => BlocProvider.of(context);


  TaskModel? taskModelId ;
  Future<void>getTaskById(
       {required String id}
      )async{
    emit(GetTaskByIdLoading());
    await DioHelper.getDate(
      url: '${AppStrings.endPointMyTasks}/$id',
    ).then((value) {
      taskModelId = TaskModel.fromJson(value.data);
      emit(GetTaskByIdSuccess(value.data));
    }).catchError((onError) {
      if(onError.response!.statusCode == 401){
        MyTasksCubit().getRefreshToken().then((value) {
          getTaskById(id: id);
        });
      }
      if (onError is DioException) {
        debugPrint(onError.response!.data['message']);
        debugPrint(onError.message);
        emit(GetTaskByIdError(onError.response!.data['message']));
      }
    });
  }
}
