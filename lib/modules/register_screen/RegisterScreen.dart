import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/layout/HomeLayout.dart';
import 'package:one_t_chat/modules/feed_screen/FeedScreen.dart';
import 'package:one_t_chat/modules/register_screen/cubit/RegisterCubit.dart';
import 'package:one_t_chat/modules/register_screen/cubit/RegisterStates.dart';
import 'package:one_t_chat/shared/components/Components.dart';
import 'package:one_t_chat/shared/ErrorHandler.dart';
import 'package:one_t_chat/shared/style/color.dart';

class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
          builder: (context, state) {
        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: CustomBoldText(
                          title: 'Sign In',
                          size: 38,
                          fontWeight: FontWeight.bold,
                          background: secondaryColor),
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
                          return 'قم بادخال البريد الالكتروني';
                        }
                        return null;
                      },
                      labelColor: secondaryColor,
                      iconColor: secondaryColor,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    defaultFormField(
                        controller: nameController,
                        borderColor: secondaryColor,
                        label: 'Name',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'قم بادخال اسمك';
                          }
                          return null;
                        },
                        prefixIcon: Icons.person,
                        iconColor: secondaryColor,
                        labelColor: secondaryColor,
                        keyboardType: TextInputType.name),
                    const SizedBox(
                      height: 50,
                    ),
                    defaultFormField(
                        controller: phoneController,
                        borderColor: secondaryColor,
                        prefixIcon: Icons.phone,
                        label: 'Phone',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'قم بادخال رقم الهاتف';
                          }
                          return null;
                        },
                        labelColor: secondaryColor,
                        iconColor: secondaryColor,
                        keyboardType: TextInputType.phone),
                    const SizedBox(
                      height: 50,
                    ),
                    passwordFormField(
                        controller: passwordController,
                        isVisible: RegisterCubit.get(context).isVisible,
                        iconColor: secondaryColor,
                        label: 'Password',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'قم بادخال كلمة المرور ';
                          }
                          return null;
                        },
                        borderColor: secondaryColor,
                        suffixIconOnPressed:
                            RegisterCubit.get(context).changeVisibility),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 60),
                      child: defaultButton(
                          width: double.infinity,
                          background: secondaryColor,
                          textColor: primaryColor,
                          radius: 20,
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              RegisterCubit.get(context).userRegister(
                                  context: context,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text);
                            }
                          },
                          child: state is! UserRegisterLoading || state is! UserCreateLoading
                              ? CustomBoldText(
                                  title: 'Sign In',
                                  size: 24,
                                  background: primaryColor)
                              : const Center(
                                  child: CircularProgressIndicator(),
                                )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }, listener: (context, state) {
        if (state is UserCreateSuccess) {
          myMsg(
              context: context,
              content: 'تم انشاء حسابك بنجاح',
              background: Colors.green);
          myNavigator(context, HomeLayout(), backButton: false);
        }
        if (state is UserCreateError) {
          String error =
              ErrorHandler.getFriendlyErrorMessage(state.error.toString());
          emailController.clear();
          passwordController.clear();
          myMsg(context: context, content: error, background: Colors.red);
        }

        if (state is UserRegisterError) {
          String error =
              ErrorHandler.getFriendlyErrorMessage(state.error.toString());
          emailController.clear();
          passwordController.clear();
          myMsg(context: context, content: error, background: Colors.red);
        }
      }),
    );
  }
}
