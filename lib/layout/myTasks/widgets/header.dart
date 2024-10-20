import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskyy/layout/profile/screens/profile.dart';
import 'package:taskyy/layout/myTasks/cubit/my_tasks_cubit.dart';


class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyTasksCubit, MyTasksState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MyTasksCubit.get(context);
        return Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            const Text('Logo',
              style: TextStyle(
                color: Color(0xFF24252C),
                fontSize: 24,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
              },
              child: Ink.image(
                  image: const AssetImage("assets/images/MyTasks/Face.png"),
                  width: 40,
                  height: 40),
            ),
            InkWell(
              onTap: () {
                cubit.logOut(context);
              },
              child: Ink.image(
                  image: const AssetImage("assets/images/MyTasks/logout.png"),
                  width: 40,
                  height: 40),
            ),
          ],
        );
      },
    );
  }
}
