import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:taskyy/layout/EditTask/screens/edit_task.dart';
import 'package:taskyy/layout/TaskDetails/cubit/get_task_by_id_cubit.dart';
import 'package:taskyy/layout/myTasks/cubit/my_tasks_cubit.dart';
import 'package:taskyy/shared/resources/string_manager.dart';
import 'package:taskyy/shared/resources/text_manager.dart';

class Taskdetails extends StatelessWidget {
  Taskdetails({super.key, required this.id,});

  final String id;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetTaskByIdCubit()..getTaskById(id: id),
      child: BlocConsumer<GetTaskByIdCubit, GetTaskByIdState>(
        listener: (context, state) {},
        builder: (context, state) {
          var getCubit = GetTaskByIdCubit.get(context);
          var myCubit = MyTasksCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text('Task Details',
                  style: AppText.w50020(),),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    myCubit.pagingController.refresh();
                  },
                  icon: Image.asset('assets/icons/Arrow-Right.png'),
                ),
                actions: [
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {} else if (value == 'delete') {}
                    },
                    icon: const Icon(Icons.more_vert),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                            value: 'edit',
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditTaskScreen(
                                        task: getCubit.taskModelId!,
                                      )));
                            },
                            child: const Opacity(
                              opacity: 0.87,
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  color: Color(0xFF00060D),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: const Opacity(
                            opacity: 0.87,
                            child: Text(
                              'Delete',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFFFF7D53),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          onTap: () {
                            myCubit.deleteTask(id: getCubit.taskModelId?.id ??'');
                            Navigator.pop(context);
                          },
                        ),
                      ];
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Image.network('${AppStrings.baseUrl}images/${getCubit.taskModelId?.image}'),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              getCubit.taskModelId?.title ?? '',
                              style: const TextStyle(
                                color: Color(0xFF24252C),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              getCubit.taskModelId?.desc ?? '',
                              style: const TextStyle(
                                color: Color(0x9924252C),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Container(
                              decoration: ShapeDecoration(
                                color: const Color(0xFFF0ECFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'End Date',
                                      style: TextStyle(
                                        color: Color(0xFF6E6A7C),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          getCubit.taskModelId?.createdAt!.split('T')[0] ?? '',
                                          style: const TextStyle(
                                            color: Color(0xFF24252C),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.calendar_month,
                                          color: Color(0xFF5F33E1),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Container(
                              decoration: ShapeDecoration(
                                color: const Color(0xFFF0ECFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(getCubit.taskModelId?.status ?? '',
                                      style: const TextStyle(
                                        color: Color(0xFF5F33E1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Color(0xFF5F33E1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Container(
                              decoration: ShapeDecoration(
                                color: const Color(0xFFF0ECFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.flag,
                                      color: Color(0xFF5F33E1),
                                    ),
                                    Text(getCubit.taskModelId?.priority ?? '',
                                      style: const TextStyle(
                                        color: Color(0xFF5F33E1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Color(0xFF5F33E1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Center(
                              child: QrImageView(
                                data: getCubit.taskModelId?.id ?? '',
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
