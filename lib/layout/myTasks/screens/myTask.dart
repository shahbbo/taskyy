import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:taskyy/layout/AddTask/Screens/add_task.dart';
import 'package:taskyy/layout/TaskDetails/screens/TaskDetails.dart';
import 'package:taskyy/layout/myTasks/cubit/my_tasks_cubit.dart';
import 'package:taskyy/layout/myTasks/widgets/barBuilder.dart';
import 'package:taskyy/layout/myTasks/widgets/task_card_buildder.dart';
import 'package:taskyy/layout/profile/screens/profile.dart';

class MyTask extends StatefulWidget {
  const MyTask({super.key});

  @override
  State<MyTask> createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void initState() {
    MyTasksCubit.get(context)
        .pagingController
        .addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }
  Future<void> _fetchPage(int pageKey) async {
    var cubit = MyTasksCubit.get(context);
    try {
      cubit.selectedPageNumber = pageKey;
      print("Current page: ${cubit.selectedPageNumber}");
      await cubit.getMyTasks();
      final tasks = cubit.myTasks;
      final state = cubit.state;
      if (state is MyTasksSuccessState) {
        if (state.lastPage) {
          cubit.pagingController.appendLastPage(tasks);
        } else {
          final nextPageKey = pageKey + 1;
          cubit.pagingController.appendPage(tasks, nextPageKey);
        }
      }
    } catch (error) {
      cubit.pagingController.error = error;
      print(error);
    }
  }

  @override
  void dispose() {
    MyTasksCubit.get(context).pagingController.dispose();
    super.dispose();
  }

  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyTasksCubit, MyTasksState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MyTasksCubit.get(context);
        return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: const Text(
                  'Logo',
                  style: TextStyle(
                    color: Color(0xFF24252C),
                    fontSize: 24,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile()));
                    },
                    child: Ink.image(
                        image:
                            const AssetImage("assets/images/MyTasks/Face.png"),
                        width: 40,
                        height: 40),
                  ),
                  InkWell(
                    onTap: () {
                      cubit.logOut(context);
                    },
                    child: Ink.image(
                        image: const AssetImage(
                            "assets/images/MyTasks/logout.png"),
                        width: 40,
                        height: 40),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () {
                  return Future.sync(() => cubit.pagingController.refresh());
                },
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'My Tasks',
                                style: TextStyle(
                                  color: Color(0xFF24252C),
                                  fontSize: 14,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Barbuilder(),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    TaskCardBuildder(
                      pagingController: cubit.pagingController,
                    )
                  ],
                ),
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'qr',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('QR Code Scanner'),
                          content: SizedBox(
                            width: 300,
                            height: 300,
                            child: QRView(
                              key: qrKey,
                              onQRViewCreated: (controller) {
                                this.controller = controller;
                                controller.scannedDataStream
                                    .listen((event) {
                                  setState(() {
                                    result = event;
                                    print(result!.code);
                                    controller.stopCamera();
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Taskdetails(
                                                  id: result!.code
                                                      .toString(),
                                                )));
                                  });
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    backgroundColor: const Color(0xFFEAE5FF),
                    child: const Icon(
                      Icons.qr_code,
                      color: Color(0xFF5F33E1),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddTask()));
                    },
                    heroTag: 'add',
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    backgroundColor: const Color(0xFF5F33E1),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
