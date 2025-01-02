import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/AppCubit.dart';
import '../../layout/cubit/AppStates.dart';
import '../../shared/components/Components.dart';
import '../../shared/components/CustomPostCard.dart';
import '../../shared/style/color.dart';
import '../../shared/style/icon_broken.dart';
import '../../shared/style/text.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return state != GetUserDataStateLoading && cubit.userModel != null
              ? Scaffold(
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Card(
                              color: myBlackColor,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: .5,
                              margin: const EdgeInsets.all(1),
                              child: const Image(
                                  image: NetworkImage(homeImage ?? ''),
                                  height: 220,
                                  width: double.infinity,
                                  fit: BoxFit.fill)),
                          const SizedBox(height: 20),
                          ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return CustomPostCard(
                                    model: cubit.posts[index], index: index);
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 2);
                              },
                              itemCount: cubit.posts.length)
                        ],
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
        listener: (context, state) {});
  }
}
