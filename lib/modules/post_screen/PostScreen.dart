import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/layout/cubit/AppCubit.dart';
import 'package:one_t_chat/layout/cubit/AppStates.dart';
import 'package:one_t_chat/shared/Constants.dart';
import 'package:one_t_chat/shared/components/Components.dart';
import 'package:one_t_chat/shared/style/color.dart';
import 'package:one_t_chat/shared/style/icon_broken.dart';
import 'package:one_t_chat/shared/style/text.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var postTextController = TextEditingController();
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: CustomBoldText(
                  title: 'Add Post', size: 24, background: myBlackColor),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: TextButton(
                      onPressed: () {
                        cubit.uploadPostImage().then((value) {
                          try {
                            if (cubit.postImageUrl != null &&
                                cubit.postImageUrl!.isNotEmpty) {
                              cubit.createPost(
                                  name: cubit.userModel?.name ?? '',
                                  profileImage:
                                      cubit.userModel?.profileImage ?? '',
                                  uId: uId,
                                  postImage: cubit.postImageUrl,
                                  dateTime: DateTime.now().toLocal().toString(),
                                  postText: postTextController.text);
                              cubit.postImage = null;
                              postTextController.text = '';
                            }
                          } catch (e) {
                            throw Exception(e.toString());
                          }
                        });
                      },
                      child: state is CreatePostLoadingState ||
                              state is UploadImagePostLoadingState
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : CustomBoldText(
                              title: 'Post Now',
                              size: 22,
                              background: secondaryColor)),
                )
              ],
            ),
            body: SingleChildScrollView(
              // update
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image(
                            image: NetworkImage(
                                cubit.userModel?.profileImage ?? ''),
                            width: 60,
                            height: 60,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomBoldText(
                            title: cubit.userModel?.name ?? '',
                            size: 18,
                            fontWeight: FontWeight.w600,
                            background: myBlackColor)
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      child: defaultFormField(
                          prefixIcon: IconBroken.Activity,
                          minLine: 5,
                          controller: postTextController,
                          keyboardType: TextInputType.multiline,
                          label: 'what you think about it',
                          labelColor: myBlackColor),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: double.infinity,
                      height: 250,
                      color: myBlackColor,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          uploadImage != '' || cubit.postImage != null
                              ? Image(
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.fill,
                                  image: cubit.postImage == null
                                      ? const NetworkImage(
                                          uploadImage ?? '',
                                        )
                                      : FileImage(cubit.postImage ?? File('')))
                              : const SizedBox(
                                  width: double.infinity,
                                  height: 250,
                                ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: secondaryColor.withOpacity(0.95),
                              child: IconButton(
                                  color: primaryColor,
                                  onPressed: () {
                                    cubit.getPostImage();
                                  },
                                  icon: Icon(
                                    IconBroken.Image,
                                    size: 35,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
