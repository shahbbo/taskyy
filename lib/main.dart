import 'package:flutter/material.dart';
import 'package:taskyy/layout/AddTask/cubit/add_task_cubit.dart';
import 'package:taskyy/layout/TaskDetails/cubit/get_task_by_id_cubit.dart';
import 'package:taskyy/layout/components/constants.dart';
import 'package:taskyy/layout/logIn/cubit/log_in_cubit.dart';
import 'package:taskyy/layout/logIn/screen/log_in.dart';
import 'package:taskyy/layout/myTasks/cubit/my_tasks_cubit.dart';
import 'package:taskyy/layout/myTasks/screens/myTask.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskyy/layout/onBoarding/screen/onboarding.dart';
import 'package:taskyy/layout/profile/cubit/profile_cubit.dart';
import 'package:taskyy/layout/signUp/cubit/sign_up_cubit.dart';
import 'package:taskyy/layout/splash/splash.dart';
import 'package:taskyy/shared/bloc_observer.dart';
import 'package:taskyy/shared/network/local/cache_helper.dart';
import 'package:taskyy/shared/network/remote/dio_helper.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.inti();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  Widget widget;
  tokenId = CacheHelper.getData(key: 'TokenId');
  onBoardingg = CacheHelper.getData(key: 'onBoarding');
  if (onBoardingg != null) {
    if (tokenId != null) {
      widget = const MyTask();
    } else {
      widget = const LogIn();
    }
  } else {
    widget = const onBoarding();
  }
  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddTaskCubit>(create: (context) => AddTaskCubit()),
        BlocProvider<LogInCubit>(create: (context) => LogInCubit()),
        BlocProvider<SignUpCubit>(create: (context) => SignUpCubit()),
        BlocProvider<MyTasksCubit>(create: (context) => MyTasksCubit()..getMyTasks()),
        BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()..getProfile()),
        BlocProvider<GetTaskByIdCubit>(create: (context) => GetTaskByIdCubit()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'DM_Sans',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(startWidget: startWidget),
      ),
    );
  }
}

