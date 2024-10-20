import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:taskyy/layout/components/default_button.dart';
import 'package:taskyy/layout/logIn/cubit/log_in_cubit.dart';
import 'package:taskyy/layout/myTasks/screens/myTask.dart';
import 'package:taskyy/layout/signUp/screens/signUp.dart';
import 'package:taskyy/shared/network/local/cache_helper.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  FocusNode focusNode = FocusNode();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String countryCode = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogInCubit, LogInState>(
      listener: (context, state) async {
        if (state is LogInSuccessState) {
          CherryToast.success(
            title: const Text('Login Successful'),
            animationType: AnimationType.fromTop,)
              .show(context);
          await CacheHelper.saveData(key: 'TokenId', value: state.data['access_token']);
          await CacheHelper.saveData(key: 'refreshToken', value: state.data['refresh_token']);
          await CacheHelper.saveData(key: 'ID',value: state.data['_id']);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyTask()),
           );
        } else if (state is LogInErrorState) {
          CherryToast.error(
            title: Text(state.message),
            animationType: AnimationType.fromTop,
          ).show(context);
        }
      },
      builder: (context, state) {
        var cubit = LogInCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 500,
                    child: Stack(
                      children: [
                        Ink.image(
                          image: const AssetImage('assets/images/logIn/Frame.png'),
                          fit: BoxFit.cover,
                        ),
                        const Positioned(
                          bottom: 40,
                          left: 22,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xFF24252C),
                              fontSize: 24,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 335,
                          child: IntlPhoneField(
                            disableLengthCheck: true,
                            controller: phoneController,
                            initialCountryCode: 'EG',
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(),
                              ),
                            ),
                            validator: (value) {
                              countryCode = value!.countryCode;
                              if (value.number.isEmpty) {
                                return 'Phone Number is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 335,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            obscuringCharacter: '*',
                            decoration: InputDecoration(
                              hintText: 'Enter Your Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        DefaultButton(
                            title: 'Sign In',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                  phone: countryCode+phoneController.text,
                                  password: passwordController.text,
                                );
                              }
                            },),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don’t have any account?',
                        style: TextStyle(
                          color: Color(0xFF6E6A7C),
                          fontSize: 14,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const signUp()),
                          );
                        },
                        child: const Text(
                          'Sign Up here',
                          style: TextStyle(
                            color: Color(0xFF5F33E1),
                            fontSize: 14,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
