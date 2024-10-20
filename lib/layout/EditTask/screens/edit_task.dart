import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskyy/layout/AddTask/cubit/add_task_cubit.dart';
import 'package:taskyy/layout/components/default_text_form_feild.dart';
import 'package:taskyy/layout/components/photoPicker.dart';
import 'package:taskyy/layout/myTasks/cubit/my_tasks_cubit.dart';
import 'package:taskyy/models/taskModels/taskModel.dart';
import 'package:taskyy/shared/resources/string_manager.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, required this.task});
  final TaskModel task;
  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController prioityController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  String image = '';
  bool isEdit = true;

  @override
  void initState() {
    titleController.text = widget.task.title ?? '';
    descriptionController.text = widget.task.desc ?? '';
    prioityController.text = widget.task.priority ?? '';
    statusController.text = widget.task.status ?? '';
    image = widget.task.image ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTaskCubit, AddTaskState>(
      listener: (context, state) {
        var cubit = AddTaskCubit.get(context);
        if (state is PostImagePickedSuccessState) {
          Navigator.pop(context);
          cubit.uploadImage(image: cubit.postImage!);
        }
        if (state is UploadImageSuccess) {
          image = state.image;
          isEdit = false;
        }
        if (state is EditTaskSuccessState) {
          CherryToast.success(
            title: const Text('Edit Success'),
            animationType: AnimationType.fromTop,
          ).show(context);
          MyTasksCubit.get(context).getMyTasks();
          cubit.postImage = null;
          Navigator.pop(context);
        }else if (state is EditTaskErrorState) {
          CherryToast.error(
            title: Text(state.message),
            animationType: AnimationType.fromTop,
          ).show(context);
        }
      },
      builder: (context, state) {
        var cubit = AddTaskCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit Task Details',
              style: TextStyle(
                color: Color(0xFF24252C),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset('assets/icons/Arrow-Right.png'),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showSelectPhotoOptions(
                          context,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF5F33E1)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              'Add Img',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF5F33E1),
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    cubit.postImage == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Container(
                              height: MediaQuery.sizeOf(context).height / 2,
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
                                    child: Image.network(
                                      '${AppStrings.baseUrl}images/${widget.task.image ?? ''}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Container(
                              height: MediaQuery.sizeOf(context).height / 2,
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
                                      cubit.postImage!,
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
                                        cubit.postImage = null;
                                        isEdit = true;
                                        setState(() {});
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
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Task title',
                              style: TextStyle(
                                color: Color(0xFF6E6A7C),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DefaultTextFormFeild(
                          valdation: 'Title is Required',
                          readOnly: false,
                          title: 'Task Title',
                          controller: titleController,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            if (widget.task.title == value) {
                              isEdit = true;
                            } else {
                              isEdit = false;
                            }
                            setState(() {});
                          },
                          label: 'Enter title here...',
                          labelStyle: const TextStyle(
                            color: Color(0xFF7F7F7F),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DefaultTextFormFeild(
                      title: 'Task Description',
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      onChanged: (value) {
                        if (widget.task.desc == value) {
                          isEdit = true;
                        } else {
                          isEdit = false;
                        }
                        setState(() {});
                      },
                      maxLines: null,
                      label: 'Enter description here...',
                      labelStyle: const TextStyle(
                        color: Color(0xFF7F7F7F),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      valdation: 'Description is Required',
                      readOnly: false,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DefaultTextFormFeild(
                      controller: prioityController,
                      style: const TextStyle(
                        color: Color(0xFF5F33E1),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      valdation: 'Priority is Required',
                      title: 'Priority',
                      readOnly: false,
                      label: 'Priority',
                      labelStyle: const TextStyle(
                        color: Color(0xFF5F33E1),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                  value: 'Heigh',
                                  child: Text('Heigh '),
                                ),
                              ],
                              onChanged: (value) {
                                prioityController.text = value.toString();
                                if (widget.task.priority == value) {
                                  isEdit = true;
                                } else {
                                  isEdit = false;
                                }
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
                      height: 16,
                    ),
                    DefaultTextFormFeild(
                      title: 'Status',
                      controller: statusController,
                      readOnly: true,
                      style: const TextStyle(
                        color: Color(0xFF5F33E1),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      valdation: 'Status is Required',
                      label: 'Status',
                      labelStyle: const TextStyle(
                        color: Color(0xFF5F33E1),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          width: 150,
                          child: DropdownMenuItem(
                            alignment: Alignment.centerRight,
                            child: DropdownButton(
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(
                                  value: 'inprogress',
                                  child: Text('InProgress'),
                                ),
                                DropdownMenuItem(
                                  value: 'waiting',
                                  child: Text('Waiting'),
                                ),
                                DropdownMenuItem(
                                  value: 'finished',
                                  child: Text('Finished'),
                                ),
                              ],
                              onChanged: (value) {
                                statusController.text = value.toString();
                                if (widget.task.status == value) {
                                  isEdit = true;
                                } else {
                                  isEdit = false;
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Conditional.single(
                      context: context,
                      conditionBuilder: (context) =>
                          state is! EditTaskLoadingState,
                      widgetBuilder: (context) => ElevatedButton(
                        onPressed: isEdit == true
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  cubit.editTask(
                                      title: titleController.text,
                                      desc: descriptionController.text,
                                      image: image,
                                      priority:
                                          prioityController.text.toLowerCase(),
                                      status: statusController.text,
                                      id: widget.task.id ?? '');
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: isEdit == true
                              ? Colors.grey
                              : const Color(0xFF5F33E1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Edit task',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      ),
                      fallbackBuilder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
