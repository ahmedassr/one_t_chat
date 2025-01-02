import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/layout/cubit/AppCubit.dart';
import 'package:one_t_chat/layout/cubit/AppStates.dart';
import 'package:one_t_chat/models/PostModel.dart';
import 'package:one_t_chat/modules/post_screen/LikesScreen.dart';

import '../../modules/post_screen/CommentsScreen.dart';
import '../style/color.dart';
import '../style/icon_broken.dart';
import 'Components.dart';

class CustomPostCard extends StatelessWidget {
  final PostModel model;
  final int index;

  const CustomPostCard({
    super.key,
    required this.model,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    var commentsController = TextEditingController();
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        foregroundImage: NetworkImage(model.profileImage ?? ''),
                        backgroundColor: secondaryColor.withOpacity(.5),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomBoldText(
                              title: model.name ?? '',
                              size: 18,
                              fontWeight: FontWeight.w600,
                              background: myBlackColor),
                          CustomBoldText(
                              title: model.dateTime.toString() ??
                                  '00/00/0000 00:00 am',
                              size: 16,
                              fontWeight: FontWeight.w500,
                              background: Colors.grey),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: myDivider(),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomBoldText(
                            title: model.postText ?? '',
                            size: 18,
                            fontWeight: FontWeight.w600,
                            background: myBlackColor,
                            maxLines: 5),
                        const SizedBox(
                          height: 5,
                        ),
                        Wrap(
                          spacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          children: [
                            InkWell(
                              child: CustomBoldText(
                                  title: '#sofotware',
                                  size: 18,
                                  background: secondaryColor),
                            ),
                          ],
                        ),
                        model.postImage != ""
                            ? Image(
                                image: NetworkImage(model.postImage ?? ''),
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(
                                    height: 10,
                                    width: double.infinity,
                                  );
                                },
                              )
                            : const SizedBox(
                                height: 10,
                                width: double.infinity,
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            IconButton(
                                onPressed: () {
                                  cubit.getPostLikes(cubit.postsId[index]);
                                  myNavigator(
                                      context,
                                      LikesScreen(
                                        likesNum: cubit.likes[index].toString(),
                                      ),
                                      backButton: true);
                                },
                                icon: Icon(
                                  IconBroken.Heart,
                                  color: Colors.red,
                                )),
                            TextButton(
                                onPressed: () {},
                                child: CustomBoldText(
                                    title: '${cubit.likes[index]}',
                                    size: 18,
                                    background: Colors.grey)),
                            Spacer(),
                            TextButton(
                                onPressed: () {},
                                child: CustomBoldText(
                                    title: '${cubit.comments[index]}',
                                    size: 18,
                                    background: Colors.grey)),
                            IconButton(
                                onPressed: () {
                                  cubit.getPostComments(cubit.postsId[index]);
                                  myNavigator(
                                      context,
                                      CommentsScreen(
                                        commentsNum:
                                            cubit.comments[index].toString(),
                                      ),
                                      backButton: true);
                                },
                                icon: const Icon(IconBroken.Chat)),
                          ],
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                                radius: 30,
                                onForegroundImageError:
                                    (exception, stackTrace) {
                                  const SizedBox(
                                    width: 30,
                                    height: 30,
                                  );
                                },
                                foregroundImage:
                                    cubit.userModel?.profileImage != null ||
                                            cubit.userModel?.profileImage != ''
                                        ? NetworkImage(
                                            cubit.userModel?.profileImage ?? '')
                                        : null),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: defaultFormField(
                                  controller: commentsController,
                                  keyboardType: TextInputType.name,
                                  label: 'Write Your Comment',
                                  prefixIcon: IconBroken.Chat,
                                  iconColor: myBlackColor),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: IconButton(
                                  onPressed: () {
                                    cubit.postComment(cubit.postsId[index],
                                        commentsController.text);
                                  },
                                  icon: Icon(
                                    IconBroken.Send,
                                    color: secondaryColor,
                                  )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                onPressed: () {
                                  cubit.postLike(cubit.postsId[index]);
                                },
                                icon: const Icon(
                                  IconBroken.Heart,
                                  color: Colors.red,
                                )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
