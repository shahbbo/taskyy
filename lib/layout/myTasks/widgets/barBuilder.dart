import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskyy/layout/AddTask/cubit/add_task_cubit.dart';
import 'package:taskyy/layout/myTasks/cubit/my_tasks_cubit.dart';

class Barbuilder extends StatefulWidget {
  const Barbuilder({super.key});

  @override
  State<Barbuilder> createState() => _BarbuilderState();
}

int _selectedIndex = 0;

List<String> bottuns = [
  'All',
  'InProgress',
  'Waiting',
  'Finished',
];

class _BarbuilderState extends State<Barbuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyTasksCubit, MyTasksState>(
      listener: (context, state) {
        var addState = AddTaskCubit.get(context).state;
        if (addState is AddTaskSuccess){
          _selectedIndex = 0;
        }
      },
      builder: (context, state) {
        var cubit = MyTasksCubit.get(context);
        return SizedBox(
          height: 60,
          child: ListView.builder(
              itemCount: bottuns.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      if (index == 0) {
                        cubit.clearData('');
                      } else if (index == 1) {
                        cubit.clearData('inprogress');
                      } else if (index == 2) {
                        cubit.clearData('waiting');
                      } else if (index == 3) {
                        cubit.clearData('finished');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == index ?
                      const Color(0xff5F33E1) :
                      const Color(0xFFEAE5FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(bottuns[index],
                      style: TextStyle(
                        color: _selectedIndex == index ?
                        Colors.white :
                        const Color(0xFF7C7C80),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
