import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskyy/layout/components/backer.dart';
import 'package:taskyy/layout/components/profile_tile.dart';
import 'package:taskyy/layout/profile/cubit/profile_cubit.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfile(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ProfileCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Back(title: 'Profile'),
                      const SizedBox(height: 40),
                      RefreshIndicator(
                        onRefresh: () async {
                          await cubit.getProfile();
                        },
                        child: Column(
                          children: [
                            ProfileTile(
                                title: 'Name',
                                value: cubit.profileModel?.displayName ?? ''),
                            const SizedBox(height: 20),
                            ProfileTile(
                                title: 'Phone',
                                value: cubit.profileModel?.username ?? ''),
                            const SizedBox(height: 20),
                            ProfileTile(
                                title: 'Level',
                                value: cubit.profileModel?.level ?? ''),
                            const SizedBox(height: 20),
                            ProfileTile(
                                title: 'Years Of Experience',
                                value: '${cubit.profileModel?.experienceYears
                                    .toString()} years'),
                            const SizedBox(height: 20),
                            ProfileTile(
                                title: 'Locaion',
                                value: cubit.profileModel?.address ?? ''),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
