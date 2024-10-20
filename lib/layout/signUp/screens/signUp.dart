import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:taskyy/layout/components/default_button.dart';
import 'package:taskyy/layout/components/default_text_form_feild.dart';
import 'package:taskyy/layout/logIn/screen/log_in.dart';
import 'package:taskyy/layout/myTasks/screens/myTask.dart';
import 'package:taskyy/layout/signUp/cubit/sign_up_cubit.dart';
import 'package:taskyy/shared/network/local/cache_helper.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  FocusNode focusNode = FocusNode();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController yOfExpController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController expLevelController = TextEditingController();
  String countryCode = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) async {
        if (state is SignUpSuccessState) {
          CherryToast.success(
            title: const Text('Register Successful'),
            animationType: AnimationType.fromTop,
          ).show(context);
          await CacheHelper.saveData(
              key: 'TokenId', value: state.data['access_token']);
          await CacheHelper.saveData(
              key: 'refreshToken', value: state.data['refresh_token']);
          await CacheHelper.saveData(key: 'ID', value: state.data['_id']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyTask()),
          );
        } else if (state is SignUpErrorState) {
          CherryToast.error(
            title: Text(state.error),
            animationType: AnimationType.fromTop,
          ).show(context);
        }
      },
      builder: (context, state) {
        var cubit = SignUpCubit.get(context);
        return SafeArea(
            child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(children: [
                  SizedBox(
                    height: 400,
                    child: Stack(
                      children: [
                        Ink.image(
                          image:
                              const AssetImage('assets/images/signup/Frame.png'),
                          fit: BoxFit.cover,
                        ),
                        const Positioned(
                          bottom: 22,
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
                  DefaultTextFormFeild(
                      label: 'Name...',
                      readOnly: false,
                      controller: nameController,
                      valdation: 'Please Enter Your Name',
                      title: ''),
                  const SizedBox(height: 25),
                  IntlPhoneField(
                    disableLengthCheck: true,
                    controller: phoneController,
                    initialCountryCode: 'EG',
                    validator: (value) {
                      countryCode = value!.countryCode;
                      if (value.number.isEmpty) {
                        return 'Please Enter Your Phone Number';
                      }
                      return null;
                    },
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(),
                      ),
                    ),
                  ),
                  DefaultTextFormFeild(
                      label: 'Years of Experience...',
                      readOnly: false,
                      controller: yOfExpController,
                      valdation: 'Please Enter Your Years of Experience',
                      title: ''),
                  const SizedBox(height: 25),
                  DefaultTextFormFeild(
                    label: 'Experience Level...',
                    controller: expLevelController,
                    title: '',
                    readOnly: true,
                    valdation: 'Please Choose Your Experience Level',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        width: 105,
                        child: DropdownMenuItem(
                          alignment: Alignment.centerRight,
                          child: DropdownButton(
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(
                                value: 'fresh',
                                child: Text('fresh '),
                              ),
                              DropdownMenuItem(
                                value: 'junior',
                                child: Text('junior '),
                              ),
                              DropdownMenuItem(
                                value: 'midLevel',
                                child: Text('midLevel '),
                              ),
                              DropdownMenuItem(
                                value: 'senior',
                                child: Text('senior '),
                              ),
                            ],
                            onChanged: (value) {
                              expLevelController.text = value.toString();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  DefaultTextFormFeild(
                    label: 'Address...',
                    controller: addressController,
                    valdation: 'Please ُEnter Your Address',
                    title: '',
                    readOnly: false,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    keyboardType: TextInputType.visiblePassword,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      labelText: 'Password...',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
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
                  const SizedBox(height: 16),
                  DefaultButton(
                    title: 'Sign Up',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit.signUp(
                            phone: countryCode + phoneController.text,
                            password: passwordController.text,
                            displayName: nameController.text,
                            experienceYears: yOfExpController.text,
                            address: addressController.text,
                            level: expLevelController.text);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
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
                            MaterialPageRoute(
                                builder: (context) => const LogIn()),
                          );
                        },
                        child: const Text(
                          'Sign In here',
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
                ]),
              ),
            ),
          ),
        ));
      },
    );
  }
}
