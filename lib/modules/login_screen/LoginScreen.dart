import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/layout/HomeLayout.dart';
import 'package:one_t_chat/modules/feed_screen/FeedScreen.dart';
import 'package:one_t_chat/modules/login_screen/cubit/LoginCubit.dart';
import 'package:one_t_chat/modules/login_screen/cubit/LoginStates.dart';
import 'package:one_t_chat/modules/register_screen/RegisterScreen.dart';
import 'package:one_t_chat/shared/components/Components.dart';
import 'package:one_t_chat/shared/style/color.dart';

import '../../shared/ErrorHandler.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(builder: (context, state) {
        return Scaffold(
          backgroundColor: primaryColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    const Image(
                      image: AssetImage('assets/images/appIcon.png'),
                      width: 150,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    defaultFormField(
                        controller: emailController,
                        borderColor: secondaryColor,
                        prefixIcon: Icons.email,
                        label: 'Email',
                        validator: (value) {
                          if (value.isEmpty) {
                            return '  قم بادخال البريد الالكتروني !';
                          }
                          return null;
                        },
                        labelColor: secondaryColor,
                        iconColor: secondaryColor,
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(
                      height: 50,
                    ),
                    passwordFormField(
                        controller: passwordController,
                        isVisible: LoginCubit.get(context).isVisible,
                        iconColor: secondaryColor,
                        label: 'Password',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'قم بادخال كلمة المرور !';
                          }
                          return null;
                        },
                        borderColor: secondaryColor,
                        suffixIconOnPressed:
                            LoginCubit.get(context).changeVisibility),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: defaultButton(
                          textColor: primaryColor,
                          width: double.infinity,
                          background: secondaryColor,
                          radius: 20,
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              LoginCubit.get(context).userLogin(
                                  context: context,
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          child: state is! UserLoginLoading
                              ? CustomBoldText(
                                  title: 'Login',
                                  size: 24,
                                  background: primaryColor)
                              : const Center(
                                  child: CircularProgressIndicator(),
                                )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OverflowBar(
                      children: [
                        CustomBoldText(
                          title: 'don\'t have account yet ',
                          size: 16,
                          background: Colors.black,
                        ),
                        TextButton(
                          onPressed: () {
                            myNavigator(context, RegisterScreen(),
                                backButton: true);
                          },
                          child: CustomBoldText(
                            title: 'Register Now!',
                            size: 18,
                            background: secondaryColor,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }, listener: (context, state) {
        if (state is UserLoginSuccess) {
          myMsg(
              context: context,
              content: 'تم تسجيل دخولك بنجاح',
              background: Colors.green);
          myNavigator(context, HomeLayout());
        }
        if (state is UserLoginError) {
          String error = ErrorHandler.getFriendlyErrorMessage(state.error.toString());
          myMsg(
              context: context,
              content: error,
              background: Colors.red);
          print('######## ERE${state.error.toString()}');
        }
      }),
    );
  }
}
