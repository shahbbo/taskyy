import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskyy/layout/EditTask/screens/edit_task.dart';
import 'package:taskyy/layout/TaskDetails/screens/TaskDetails.dart';
import 'package:taskyy/layout/myTasks/cubit/my_tasks_cubit.dart';
import 'package:taskyy/models/taskModels/taskModel.dart';
import 'package:taskyy/shared/resources/string_manager.dart';

class TaskCard extends StatelessWidget {
   TaskCard({super.key, required this.mytasks});

   final TaskModel mytasks;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyTasksCubit, MyTasksState>(
      listener: (context, state) {
        var cubit = MyTasksCubit.get(context);
        if (state is DeleteTaskSuccess) {
          CherryToast.success(
            title: const Text('Task Deleted Successfully'),
            animationType: AnimationType.fromTop,
          ).show(context);
          cubit.pagingController.refresh();
        }else if (state is DeleteTaskError) {
          CherryToast.error(
            title: Text(state.message),
            animationType: AnimationType.fromTop,
          ).show(context);
        }
      },
      builder: (context, state) {
        var cubit = MyTasksCubit.get(context);
        return InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Taskdetails(
                  id: mytasks.id??'',
                )));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage : NetworkImage('${AppStrings.baseUrl}images/${mytasks.image ?? ''}'),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              mytasks.title??'',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Color(0xFF24252C),
                                fontSize: 16,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            // width: 60,
                            height: 22,
                            decoration: ShapeDecoration(
                              color: mytasks.status=='inprogress'
                                  ? const Color(0xFFF0ECFF)
                                  : mytasks.status=='waiting'
                                  ? const Color(0xFFFFE4F2)
                                  :  const Color(0xFFE3F2FF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  mytasks.status??'',
                                  style: TextStyle(
                                    color: mytasks.status=='inprogress'
                                        ? const Color(0xFF5F33E1)
                                        : mytasks.status=='waiting'
                                            ? const Color(0xFFFF7D53)
                                            :  const Color(0xFF0087FF),
                                    fontSize: 12,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w500,
                                    height: 0.12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              mytasks.desc??'',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Color(0x9924252C),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.flag_outlined,
                                  size: 12,
                                  color: mytasks.priority=='low'
                                      ? const Color(0xFF0087FF)
                                      : mytasks.priority=='medium'
                                      ? const Color(0xFFFF7D53)
                                      :  const Color(0xFF5F33E1)),
                              const SizedBox(width: 4),
                              Text(mytasks.priority??'',
                                  style:  TextStyle(
                                    color: mytasks.priority=='low'
                                        ? const Color(0xFF0087FF)
                                        : mytasks.priority=='medium'
                                            ? const Color(0xFFFF7D53)
                                            :  const Color(0xFF5F33E1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Text(mytasks.createdAt!.split('T')[0],
                                  style: const TextStyle(
                                    color: Color(0xFF6E6A7C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
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
                                      task: mytasks,
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
                        onTap: () {
                          cubit.deleteTask(id: mytasks.id??'');
                        },
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
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
