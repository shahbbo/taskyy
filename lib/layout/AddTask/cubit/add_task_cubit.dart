import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mime/mime.dart';
import 'package:taskyy/layout/components/constants.dart';
import 'package:taskyy/layout/myTasks/cubit/my_tasks_cubit.dart';
import 'package:taskyy/shared/network/local/cache_helper.dart';
import 'package:taskyy/shared/network/remote/dio_helper.dart';
import 'package:taskyy/shared/resources/string_manager.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskInitial());

  static AddTaskCubit get(context) => BlocProvider.of(context);


  File? postImage;
  var picker = ImagePicker();
  Future<void> getPostImage(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      print(postImage.toString());
      emit(PostImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(PostImagePickedErrorState());
    }
  }

  // Future<void> uploadImage({
  //   required File image,
  // }) async {
  //   emit(UploadImageLoading());
  //   final String fileExtension = image.path.split('.').last.toLowerCase();
  //   final String type = fileExtension == 'jpg' || fileExtension == 'jpeg'
  //       ? 'image/jpeg'
  //       : fileExtension == 'png'
  //       ? 'image/png'
  //       : fileExtension == 'gif'
  //       ? 'image/gif'
  //       : 'application/octet-stream';
  //   FormData formData = FormData.fromMap({
  //     'image': MultipartFile.fromBytes(
  //       image.readAsBytesSync(),
  //       filename: image.path
  //           .split('/')
  //           .last,
  //       contentType: MediaType.parse(type),
  //     ),
  //   });
  //   await DioHelper.postData(
  //     url: 'upload/image',
  //     data: formData,
  //   ).then((value) {
  //     print('image: ${value.data['image']}');
  //     emit(UploadImageSuccess(value.data['image']));
  //   }).catchError((onError) {
  //     if (onError is DioException) {
  //       if (onError.response!.statusCode == 401) {
  //         MyTasksCubit().getRefreshToken().then((value) {
  //           uploadImage(image: postImage!);
  //         });
  //       }
  //       print(onError.message);
  //       print(onError.response);
  //       print(onError.response!.data['message']);
  //       emit(UploadImageError(onError.response!.data['message']));
  //     }
  //   });
  // }

  // Future<void> uploadImage({
  //   required File image,
  // }) async {
  //   try {
  //     emit(UploadImageLoading());
  //     final List<int>? compressedImage = await FlutterImageCompress.compressWithFile(
  //       image.absolute.path,
  //       minWidth: 800,
  //       minHeight: 600,
  //       quality: 80,
  //     );
  //     if (compressedImage == null) {
  //       emit(UploadImageError('Failed to compress image'));
  //       return;
  //     }
  //     final String fileExtension = image.path.split('.').last.toLowerCase();
  //     final String type = lookupMimeType(image.path) ?? 'application/octet-stream';
  //     FormData formData = FormData.fromMap({
  //       'image': MultipartFile.fromBytes(
  //         compressedImage,
  //         filename: '${image.path.split('/').last.split('.').first}.$fileExtension',
  //         contentType: MediaType.parse(type),
  //       ),
  //     });
  //     await DioHelper.postData(
  //       url: 'upload/image',
  //       data: formData,
  //     ).then((value) {
  //       print('image: ${value.data['image']}');
  //       emit(UploadImageSuccess(value.data['image']));
  //     }).catchError((onError) {
  //       if (onError is DioException) {
  //         if (onError.response?.statusCode == 401) {
  //           MyTasksCubit().getRefreshToken().then((value) {
  //             uploadImage(image: image);
  //           });
  //         }
  //         print(onError.message);
  //         print(onError.response);
  //         print(onError.response?.data['message']);
  //         emit(UploadImageError(onError.response?.data['message'] ?? 'Error uploading image'));
  //       }
  //     });
  //   } catch (error) {
  //     print('Error: $error');
  //     emit(UploadImageError('Unexpected error occurred'));
  //   }
  // }

  Future<FormData?> prepareImageData(File image) async {
    final List<int>? compressedImage = await FlutterImageCompress.compressWithFile(
      image.absolute.path,
      minWidth: 800,
      minHeight: 600,
      quality: 80,
    );
    if (compressedImage == null) {
      return null;
    }
    final String fileExtension = image.path.split('.').last.toLowerCase();
    final String type = lookupMimeType(image.path) ?? 'application/octet-stream';
    return FormData.fromMap({
      'image': MultipartFile.fromBytes(
        compressedImage,
        filename: '${image.path.split('/').last.split('.').first}.$fileExtension',
        contentType: MediaType.parse(type),
      ),
    });
  }

  Future<void> uploadImage({
    required File image,
  }) async {
    try {
      emit(UploadImageLoading());
      final formData = await prepareImageData(image);
      if (formData == null) {
        emit(UploadImageError('فشل في ضغط الصورة'));
        return;
      }
      await DioHelper.postData(
        url: 'upload/image',
        data: formData,
      ).then((value) {
        print('image: ${value.data['image']}');
        emit(UploadImageSuccess(value.data['image']));
      }).catchError((onError) {
        if (onError is DioException) {
          if (onError.response?.statusCode == 401) {
            MyTasksCubit().getRefreshToken().then((value) {
              uploadImage(image: image);
            });
          }
          print(onError.message);
          print(onError.response);
          print(onError.response?.data['message']);
          emit(UploadImageError(onError.response?.data['message'] ?? 'Error uploading image'));
        }
      });
    } catch (error) {
      print('Error: $error');
      emit(UploadImageError('حدث خطأ غير متوقع'));
    }
  }


  Future<void> addTask({
    required String image,
    required String title,
    required String desc,
    required String priority,
    required String dueDate,
  }) async {
    print('image: $image\n'
        'title: $title\n'
        'desc: $desc\n'
        'priority: $priority\n'
        'dueDate: $dueDate\n');
    emit(AddTaskLoading());
    try {
      await DioHelper.postData(
        url: AppStrings.endPointMyTasks,
        data: {
          'image': image,
          'title': title,
          'desc': desc,
          'priority': priority,
          'dueDate': dueDate,
        },
      ).then((value) async {
        emit(AddTaskSuccess());
      });
    } on DioException catch (onError) {
      if (onError.response != null && onError.response!.statusCode == 401) {
        await MyTasksCubit().getRefreshToken();
        await addTask(
          image: image,
          title: title,
          desc: desc,
          priority: priority,
          dueDate: dueDate,
        );
      } else {
        print(onError.response?.data['message']);
        emit(AddTaskError(onError.response?.data['message'] ?? 'Unknown error'));
      }
    } catch (e) {
      print(e);
      emit(AddTaskError('An unexpected error occurred'));
    }
  }


  Future<void> editTask({
    required String image,
    required String title,
    required String desc,
    required String priority,
    required String status,
    required String id,
  }) async{
    emit(EditTaskLoadingState());
    uid = CacheHelper.getData(key: 'ID');
    await DioHelper.putData(
        url: '${AppStrings.endPointMyTasks}/$id',
        data: {
          "image": image,
          "title": title,
          "desc": desc,
          "priority": priority,
          "status": status,
          "user": uid,
        }
    ).then((value) {
      print(value.data);
      emit(EditTaskSuccessState());
    }).catchError((onError) {
      if (onError is DioException) {
        if(onError.response!.statusCode == 401){
          MyTasksCubit().getRefreshToken().then((value) {
            editTask(
              image: image,
              title: title,
              desc: desc,
              priority: priority,
              status: status,
              id: id,
            );
          });
        }
        debugPrint(onError.response!.data['message']);
        debugPrint(onError.message);
        emit(EditTaskErrorState(onError.response!.data['message']));
      }
    });
  }
}
