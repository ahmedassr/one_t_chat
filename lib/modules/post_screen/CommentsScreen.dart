import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/AppCubit.dart';
import '../../layout/cubit/AppStates.dart';
import '../../shared/components/Components.dart';
import '../../shared/style/color.dart';
import '../../shared/style/icon_broken.dart';

class CommentsScreen extends StatelessWidget {
  final String commentsNum;

  const CommentsScreen({super.key, required this.commentsNum});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return state is! GetPostCommentsLoadingState
              ? Scaffold(
                  appBar: AppBar(
                    title: CustomBoldText(
                        title: 'Comments', size: 22, background: myBlackColor),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: CustomBoldText(
                            title: '${commentsNum} comment on post ',
                            size: 18,
                            background: Colors.grey),
                      ),
                    ],
                  ),
                  body: cubit.usersCommentsPost != null &&
                          cubit.usersCommentsPost!.isNotEmpty
                      ? ListView.separated(
                          itemBuilder: (context, index) {
                            var model = cubit.usersCommentsPost?[index];
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomBoldText(
                                        title: model?.name ?? '',
                                        size: 18,
                                        fontWeight: FontWeight.w600,
                                        background: myBlackColor),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            const Icon(IconBroken.Chat),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            CustomBoldText(
                                                title:
                                                    cubit.commentBody?[index] ??
                                                        '',
                                                size: 18,
                                                fontWeight: FontWeight.w600,
                                                background: myBlackColor),
                                          ],
                                        ),
                                      ),
                                    )
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
                          itemCount: cubit.usersCommentsPost?.length ?? 0)
                      : state is! GetPostCommentsErrorState
                          ? Center(
                              child: CustomBoldText(
                                  title: 'No Comments Added Yet',
                                  size: 24,
                                  background: myBlackColor),
                            )
                          : Center(
                              child: CustomBoldText(
                                  title: 'Some Thing Error Here, Try Later',
                                  size: 24,
                                  background: Colors.red),
                            ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
        listener: (context, state) {});
  }
}
