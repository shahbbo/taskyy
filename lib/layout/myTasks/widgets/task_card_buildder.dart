import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:taskyy/layout/myTasks/cubit/my_tasks_cubit.dart';
import 'package:taskyy/layout/myTasks/widgets/task_card.dart';
import 'package:taskyy/models/taskModels/taskModel.dart';

class TaskCardBuildder extends StatelessWidget {
  const TaskCardBuildder({super.key, required this.pagingController, });

  // ScrollController scrollController = ScrollController();

  final PagingController<int, TaskModel> pagingController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyTasksCubit, MyTasksState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MyTasksCubit.get(context);
        return state is MyTasksLoadingState && cubit.selectedPageNumber == 1
            ? const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              )
            : cubit.myTasks.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        "No Tasks Yet",
                        style: TextStyle(
                          color: Color(0xFF5F33E1),
                          fontFamily: 'DM Sans',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : SliverFillRemaining(
                    fillOverscroll: true,
                    child: PagedListView<int, TaskModel>(
                      pagingController: pagingController,
                      builderDelegate: PagedChildBuilderDelegate<TaskModel>(
                        itemBuilder: (context,item, index) {
                          if (index >= cubit.myTasks.length) {
                            return SizedBox.shrink();}
                            return TaskCard(
                              mytasks: cubit.myTasks[index],
                            );
                        },
                      ),
                    ),
                  );
      },
    );
  }
}
