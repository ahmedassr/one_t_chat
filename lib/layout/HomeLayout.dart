import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/layout/cubit/AppCubit.dart';
import 'package:one_t_chat/layout/cubit/AppStates.dart';
import 'package:one_t_chat/shared/style/icon_broken.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: cubit.currentIndex == 2
              ? null
              : AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    cubit.title[cubit.currentIndex],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
          body: cubit.screen[cubit.currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: cubit.currentIndex,
            onDestinationSelected: (index) {
              cubit.navBarChangeIndex(index, context);
            },
            destinations: const [
              NavigationDestination(icon: Icon(IconBroken.Home), label: 'Home'),
              NavigationDestination(icon: Icon(IconBroken.Chat), label: 'Chat'),
              NavigationDestination(
                  icon: Icon(IconBroken.Paper_Upload), label: 'Post'),
              NavigationDestination(
                  icon: Icon(IconBroken.User), label: 'Users'),
              NavigationDestination(
                  icon: Icon(IconBroken.Setting), label: 'Profile'),
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
