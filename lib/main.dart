import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/layout/HomeLayout.dart';
import 'package:one_t_chat/layout/cubit/AppCubit.dart';
import 'package:one_t_chat/layout/cubit/AppStates.dart';
import 'package:one_t_chat/network/local/CashHelper.dart';
import 'package:one_t_chat/network/remote/DioHelper.dart';
import 'package:one_t_chat/shared/Constants.dart';
import 'package:one_t_chat/shared/MyBlocObserver.dart';
import 'package:one_t_chat/shared/components/Components.dart';
import 'package:one_t_chat/shared/firebase/CustomFirebaseMessage.dart';
import 'package:one_t_chat/shared/style/color.dart';

import 'modules/login_screen/LoginScreen.dart';
import 'modules/welcome_screen/WelcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CashHelper.init();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  accessToken = await CustomFirebaseMessage().getAccessToken();
  CustomFirebaseMessage().saveUserToken();
  Widget firstWidget = theFirstWidget();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(MyApp(
    startWidget: firstWidget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({required this.startWidget, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getPosts()
        ..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OneT',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        home: startWidget,
      ),
    );
  }
}

Widget theFirstWidget() {
  Widget firstWidget;
  isNewUser = CashHelper.getBool(key: 'isNewUser?');
  uId = CashHelper.getString(key: 'uId') ?? '';
  if (isNewUser ?? true) {
    firstWidget = const WelcomeScreen();
  } else {
    if (uId != '') {
      firstWidget = HomeLayout();
    } else {
      firstWidget = LoginScreen();
    }
  }
  return firstWidget;
}
