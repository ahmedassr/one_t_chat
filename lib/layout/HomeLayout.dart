import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/layout/cubit/AppCubit.dart';
import 'package:one_t_chat/layout/cubit/AppStates.dart';
import 'package:one_t_chat/shared/components/Components.dart';
import 'package:one_t_chat/shared/components/CustomPostCard.dart';
import 'package:one_t_chat/shared/style/color.dart';
import 'package:one_t_chat/shared/style/icon_broken.dart';
import 'package:one_t_chat/shared/style/text.dart';

class HomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: cubit.currentIndex != 4 ?
          AppBar(
              titleSpacing: 10,
              automaticallyImplyLeading: false,
              actions: [
                if(cubit.currentIndex != 4)
                IconButton(
                    onPressed: () {},
                    icon: const Icon(IconBroken.Notification)),
                if (cubit.currentIndex == 4)
                  TextButton(
                      onPressed: () {

                      },
                      child: CustomBoldText(
                          title: 'Update',
                          size: 23,
                          background: secondaryColor))
              ],
              title: CustomBoldText(
                  title: cubit.title[cubit.currentIndex],
                  size: 24,
                  background: myBlackColor)) : null,
          body: cubit.screen[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                cubit.navBarChangeIndex(index, context);
              },
              currentIndex: cubit.currentIndex,
              selectedItemColor: secondaryColor,
              unselectedItemColor: Colors.grey,
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(IconBroken.Home), label: 'Home'),
                const BottomNavigationBarItem(
                    icon: Icon(IconBroken.Chat), label: 'Chat'),
                BottomNavigationBarItem(
                    icon: Icon(
                      IconBroken.Paper_Upload,
                      size: 35,
                      color: Colors.blueAccent,
                    ),
                    label: 'Post',
                    backgroundColor: secondaryColor),
                const BottomNavigationBarItem(
                    icon: Icon(IconBroken.User), label: 'Users'),
                const BottomNavigationBarItem(
                    icon: Icon(IconBroken.Setting), label: 'Setting'),
              ]),
        );
      },
      listener: (context, state) {},
    );
  }
}
