import 'package:flutter/material.dart';
import 'package:taskyy/layout/logIn/screen/log_in.dart';
import 'package:taskyy/shared/network/local/cache_helper.dart';

class onBoarding extends StatelessWidget {
  const onBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
          Column(
            children: [
              SizedBox(
                height: 500,
                child: Ink.image(
                  image: AssetImage('assets/images/logIn/Frame.png'),
                  fit: BoxFit.cover,
                  height: 500,
                ),
              ),
              Container(
                width: 375,
                height: 150,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Task Management &\nTo-Do List',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF24252C),
                        fontSize: 24,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'This productive tool is designed to help\nyou better manage your task \nproject-wise conveniently!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6E6A7C),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  CacheHelper.saveData(key: 'onBoarding', value: true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogIn()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 16,),
                  width: 335,
                  height: 51,
                  decoration: BoxDecoration(
                    color: Color(0xFF5F33E1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Let’s Start',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      Image.asset('assets/icons/Arrow-Left.png')
                    ],
                  ),
                ),
              )
            ],
          ),
      ),
    );
  }
}
