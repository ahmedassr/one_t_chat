import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/modules/login_screen/cubit/LoginStates.dart';

import '../../../models/UserModel.dart';
import '../../../network/local/CashHelper.dart';
import '../../../shared/Constants.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isVisible = false;

  void changeVisibility() {
    isVisible = !isVisible;
    emit(ChangeLoginPasswordVisibility());
  }

  void userLogin(
      {required BuildContext context,
      required String email,
      required String password}) {
    emit(UserLoginLoading());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await CashHelper.putValue(key: 'uId', value: value.user?.uid ?? '')
          .then((value) {
           uId =  CashHelper.getString(key: 'uId') ?? '';
      });
      await Future.delayed(const Duration(seconds: 1));
      emit(UserLoginSuccess());
    }).catchError((error) {
      emit(UserLoginError(error.toString()));
    });
  }
}
