import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:taskyy/layout/splash/splash.dart';
import 'package:taskyy/layout/logIn/screen/log_in.dart';
import 'package:taskyy/models/taskModels/taskModel.dart';
import 'package:taskyy/layout/components/constants.dart';
import 'package:taskyy/shared/resources/string_manager.dart';
import 'package:taskyy/shared/network/remote/dio_helper.dart';
import 'package:taskyy/shared/network/local/cache_helper.dart';

part 'my_tasks_state.dart';

class MyTasksCubit extends Cubit<MyTasksState> {
  MyTasksCubit() : super(MyTasksInitial());

  static MyTasksCubit get(context) => BlocProvider.of(context);

  String status = '';
  List<TaskModel> myTasks = [];
  int selectedPageNumber = 1;

  final PagingController<int, TaskModel> pagingController = PagingController(firstPageKey: 1);

  String _buildUrl(int pageKey ,String status) {
    return (status.isNotEmpty)
        ? '${AppStrings.endPointMyTasks}?page=$pageKey&status=$status'
        : '${AppStrings.endPointMyTasks}?page=$pageKey';
  }
  Future<void> getMyTasks() async {
    emit(MyTasksLoadingState());
    String url = _buildUrl(selectedPageNumber ,status);
    await DioHelper.getDate(
      url: url,
    ).then((value) {
      print(url);
      var newTasks = (value.data as List).map((e) => TaskModel.fromJson(e)).toList();
      print(newTasks.toString());
      if (selectedPageNumber == 1) {
        myTasks = newTasks;
        pagingController.itemList = myTasks;
      } else if ( newTasks.isNotEmpty && selectedPageNumber > 1) {
        newTasks.forEach((task) {
          if (!myTasks.contains(task)) {
            myTasks.add(task);
          }
        });
        // myTasks.addAll(newTasks);
        pagingController.appendPage(newTasks, selectedPageNumber + 1);
        print(myTasks);
      }
      if (newTasks.isEmpty && selectedPageNumber > 1) {
        emit(MyTasksSuccessState(lastPage: true));
      }
      else {
        emit(MyTasksSuccessState(lastPage: false));
      }
    }).catchError((onError) async {
      if (onError is DioException) {
        if (onError.response != null && onError.response!.statusCode == 401) {
          await getRefreshToken();
          getMyTasks();
        } else {
          debugPrint(onError.response?.data['message']);
          debugPrint(onError.message);
          emit(MyTasksErrorState(onError.response?.data['message'] ?? 'Unknown error'));
        }
      } else {
        debugPrint('Non-Dio error: $onError');
        emit(MyTasksErrorState('An unexpected error occurred'));
      }
    });
  }
  Future<void> clearData(
      String newstatus,
      ) async{
    status = newstatus;
    myTasks.clear();
    pagingController.itemList = [];
    selectedPageNumber = 1;
    pagingController.refresh();
    await getMyTasks();
  }

  Future<void>logOut(context)async{
    emit(LogoutLoading());
    tokenId = CacheHelper.getData(key: 'TokenId');
    await DioHelper.postData(
      url: AppStrings.endPointLogout,
      data: {
        'token': tokenId,
      },
    ).then((value) {
      CacheHelper.clearData(key: 'ID').
      then((value) {
        CacheHelper.clearData(key: 'TokenId');
        if (value == true) {
          myTasks = [];
          navigateFish(context,const LogIn());
        }
      });
      if (tokenId != null || uid != null) {
        tokenId = null;
        uid = null;
        debugPrint("token in side if condition: $tokenId uid : $uid");
      }
      debugPrint('token : $tokenId');
      debugPrint('uid: $uid');
      emit(LogoutSuccess(value.data));
    }).catchError((onError) {
      if (onError is DioException) {
        debugPrint(onError.response!.data['message']);
        debugPrint(onError.message);
        emit(LogoutError(onError.response!.data['message']));
      }
    });
  }

  Future<void>getRefreshToken()async{
    emit(RefreshTokenLoading());
    refreshToken = CacheHelper.getData(key: 'refreshToken');
    await DioHelper.getDate(
      url: 'auth/refresh-token?token=$refreshToken',
    ).then((value) {
      CacheHelper.saveData(key: 'TokenId', value: value.data['access_token']);
      emit(RefreshTokenSuccess());
    }).catchError((onError) {
      if (onError is DioException) {
        debugPrint(onError.response!.statusCode.toString());
        debugPrint(onError.response!.data['message']);
        emit(RefreshTokenError(onError.response!.data['message']));
      }
    });
  }

  TaskModel? taskModel ;
  Future<void>getTaskById(
      {required String id}
      )async{
    emit(GetTaskByIdLoading());
    await DioHelper.getDate(
      url: '${AppStrings.endPointMyTasks}/$id',
    ).then((value) {
      taskModel = TaskModel.fromJson(value.data);
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

  Future<void>deleteTask({required String id})async{
    emit(DeleteTaskLoading());
    await DioHelper.deleteData(
      url: '${AppStrings.endPointMyTasks}/$id',
    ).then((value) {
      emit(DeleteTaskSuccess(value.data));
    }).catchError((onError) {
      if(onError.response!.statusCode == 401){
        getRefreshToken().then((value) {
          deleteTask(id: id);
        });
      }
      if (onError is DioException) {
        debugPrint(onError.response!.data['message']);
        debugPrint(onError.message);
        emit(DeleteTaskError(onError.response!.data['message']));
      }
    });
  }
}

