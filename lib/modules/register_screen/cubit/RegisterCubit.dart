import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/models/UserModel.dart';
import 'package:one_t_chat/modules/register_screen/cubit/RegisterStates.dart';
import 'package:one_t_chat/network/local/CashHelper.dart';
import 'package:one_t_chat/shared/components/Components.dart';
import 'package:one_t_chat/shared/style/text.dart';

import '../../../shared/Constants.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isVisible = false;

  void changeVisibility() {
    isVisible = !isVisible;
    emit(ChangeSignInPasswordVisibility());
  }

  void userRegister({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(UserRegisterLoading());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userCreate(
        email: email,
        name: name,
        phone: phone,
        uid: value.user?.uid ?? '',
      ).then((value) async {
        emit(UserRegisterSuccess());
      });
    }).catchError((error) {
      print(error.toString());
      emit(UserRegisterError(error.toString()));
    });
  }

  Future<void> userCreate({
    required String email,
    required String name,
    required String phone,
    required String uid,
  }) async {
    emit(UserCreateLoading());
    UserModel model = UserModel(
      name: name,
      phone: phone,
      bio: 'write your bio',
      coverImage: blackImage,
      profileImage: defaultProfileImage,
      email: email,
      uId: uid,
    );
    try {
     await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(model.toMap());
      await CashHelper.putValue(key: 'uId', value: uid).then((value) {
        uId = CashHelper.getString(key: 'uId') ?? '';
      });

      await Future.delayed(const Duration(seconds: 2));
      emit(UserCreateSuccess());
    } catch (error) {
      emit(UserCreateError(error.toString()));
    }
  }
}
