import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/layout/cubit/AppCubit.dart';
import 'package:one_t_chat/layout/cubit/AppStates.dart';
import 'package:one_t_chat/shared/components/Components.dart';

import '../../shared/style/color.dart';
import '../../shared/style/icon_broken.dart';

class LikesScreen extends StatelessWidget {
  final String likesNum;

  const LikesScreen({super.key, required this.likesNum});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    print('!!!!!!!!!!!1${cubit.usersLikePost?.length}');
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: CustomBoldText(
                  title: 'Likes', size: 22, background: myBlackColor),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: CustomBoldText(
                      title: '${likesNum} like post ',
                      size: 18,
                      background: Colors.grey),
                ),
              ],
            ),
            body: state is! GetPostLikesLoadingState
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (cubit.usersLikePost?.length ?? 0) > 0
                        ? ListView.separated(
                            itemBuilder: (context, index) {
                              var model = cubit.usersLikePost?[index];
                              return Row(
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    foregroundImage:
                                        NetworkImage(model?.profileImage ?? ''),
                                    backgroundColor:
                                        secondaryColor.withOpacity(.5),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomBoldText(
                                          title: model?.name ?? '',
                                          size: 18,
                                          fontWeight: FontWeight.w600,
                                          background: myBlackColor),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        IconBroken.Send,
                                        color: secondaryColor,
                                      ))
                                ],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return myDivider();
                            },
                            itemCount: cubit.usersLikePost?.length ?? 0)
                        : CustomBoldText(
                            title: 'No Likes Added Yet',
                            size: 24,
                            background: myBlackColor),
                  )
                : state is! GetPostLikesErrorState
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                        child: CustomBoldText(
                            title: 'Some Thing Error Here Try Later',
                            size: 24,
                            background: Colors.red),
                      ),
          );
        },
        listener: (context, state) {});
  }
}
