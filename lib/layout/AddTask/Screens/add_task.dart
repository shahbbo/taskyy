import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:taskyy/layout/components/default_button.dart';
import 'package:taskyy/layout/components/default_text_form_feild.dart';
import 'package:taskyy/layout/components/photoPicker.dart';
import 'package:taskyy/layout/AddTask/cubit/add_task_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskyy/layout/myTasks/cubit/my_tasks_cubit.dart';
import 'package:taskyy/shared/resources/asset_manager.dart';
import 'package:taskyy/shared/resources/text_manager.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController prioityController = TextEditingController();
  int flagcolor = 0xFF24252C;
  String imageUrl = '';
  String priority = '';
  @override
  void initState() {
    super.initState();
    // Reset image and other fields when the screen opens
    AddTaskCubit.get(context).postImage = null;
    imageUrl = ''; // Reset image URL
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTaskCubit, AddTaskState>(
      listener: (context, state) {
        var addCubit = AddTaskCubit.get(context);
        var myCubit = MyTasksCubit.get(context);
        if (state is PostImagePickedSuccessState) {
          Navigator.pop(context);
          addCubit.uploadImage(image: addCubit.postImage!);
        } else if (state is UploadImageSuccess) {
          print(imageUrl);
          print('Image uploaded successfully: ${state.image}');
          CherryToast.success(
            title: const Text('Photo added successfully'),
            animationType: AnimationType.fromTop,
          ).show(context);
          setState(() {
            imageUrl = state.image;
          });
        } else if (state is AddTaskSuccess) {
          CherryToast.success(
            title: const Text('Task added successfully'),
            animationType: AnimationType.fromTop,
          ).show(context);
          Navigator.pop(context);
          myCubit.pagingController.refresh();
          addCubit.postImage == null;
        } else if (state is AddTaskError) {
          CherryToast.error(
            title: Text(state.message),
            animationType: AnimationType.fromTop,
          ).show(context);
        }
      },
      builder: (context, state) {
        var addCubit = AddTaskCubit.get(context);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(AssetsManager.iconBack),
              ),
              title: Text(
                'Add new task',
                style: AppText.w70022(),
              ),
            ),
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showSelectPhotoOptions(context);
                        },
                        child: addCubit.postImage == null
                            ? Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF5F33E1),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: Color(0xFF5F33E1),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Add photo',
                                      style: TextStyle(
                                        color: Color(0xFF5F33E1),
                                        fontSize: 22,
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          addCubit.postImage!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              addCubit.postImage = null;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultTextFormFeild(
                        label: 'Enter title here...',
                        readOnly: false,
                        title: 'Task Title',
                        controller: titleController,
                        valdation: 'Please enter title',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultTextFormFeild(
                        label: 'Enter description here...',
                        readOnly: false,
                        title: 'Task Description',
                        controller: descriptionController,
                        valdation: 'Please enter Description',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultTextFormFeild(
                        style: const TextStyle(
                          color: Color(0xFF5F33E1),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        label: 'Priority',
                        readOnly: false,
                        title: 'Priority',
                        controller: prioityController,
                        valdation: 'Please enter priority',
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0),
                          child: SizedBox(
                            width: 100,
                            child: DropdownMenuItem(
                              alignment: Alignment.centerRight,
                              child: DropdownButton(
                                underline: const SizedBox(),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Low',
                                    child: Text('Low '),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Medium',
                                    child: Text('Medium '),
                                  ),
                                  DropdownMenuItem(
                                    value: 'High',
                                    child: Text('High '),
                                  ),
                                ],
                                onChanged: (value) {
                                  prioityController.text = value.toString();
                                  priority = value.toString();
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ),
                        prefixxIcon: const Icon(
                          Icons.flag,
                          color: Color(0xFF5F33E1),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultTextFormFeild(
                        label: 'choose due date...',
                        readOnly: true,
                        title: 'Due Date',
                        controller: dueDateController,
                        valdation: 'Please enter due date',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030),
                              ).then((onValue) {
                                setState(() {
                                  dueDateController.text =
                                      onValue.toString().split(' ')[0];
                                });
                              });
                            });
                          },
                          icon: const Icon(
                            Icons.calendar_month,
                            color: Color(0xFF5F33E1),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      DefaultButton(
                        title: 'Add Task',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // Check for non-empty values before adding the task
                            if (imageUrl.isNotEmpty && titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty &&
                                priority.isNotEmpty && dueDateController.text.isNotEmpty) {
                              addCubit.addTask(
                                image: imageUrl,
                                title: titleController.text,
                                desc: descriptionController.text,
                                priority: priority.toLowerCase(),
                                dueDate: dueDateController.text,
                              );
                            } else {
                              CherryToast.error(
                                title: const Text('Please fill all fields'),
                                animationType: AnimationType.fromTop,
                              ).show(context);
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
