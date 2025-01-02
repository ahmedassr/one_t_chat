import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/AppCubit.dart';
import '../../layout/cubit/AppStates.dart';
import '../../shared/components/Components.dart';
import '../../shared/components/CustomChatCard.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Scaffold(
              body: state is! GetUsersLoadingState
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return CustomChatCard(model: cubit.users[index]);
                      },
                      itemCount: cubit.users.length ?? 0,
                    )
                  : state is! GetUsersErrorState
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: CustomBoldText(
                              title: 'Some Thing Error Here Try Later',
                              size: 24,
                              background: Colors.red),
                        ));
        },
        listener: (context, state) {});
  }
}
