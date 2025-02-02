import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/layout/cubit/AppCubit.dart';
import 'package:one_t_chat/layout/cubit/AppStates.dart';
import 'package:one_t_chat/shared/components/Components.dart';
import 'package:one_t_chat/shared/components/CustomeProfileContainer.dart';
import 'package:one_t_chat/shared/style/color.dart';
import 'package:one_t_chat/shared/style/icon_broken.dart';
import 'package:one_t_chat/shared/style/text.dart';

class ProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    nameController.text = cubit.userModel?.name ?? '';
    phoneController.text = cubit.userModel?.phone ?? '';
    bioController.text = cubit.userModel?.bio ?? '';

    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
                titleSpacing: 10,
                actions: [
                  TextButton(
                      onPressed: () {
                        cubit.updateUserData(
                            profileImage: cubit.profileImageUrl ??
                                cubit.userModel?.profileImage,
                            bio: bioController.text,
                            coverImage: cubit.coverImageUrl ??
                                cubit.userModel?.coverImage,
                            name: nameController.text,
                            phone: phoneController.text);
                      },
                      child: state is! UpdateUserDataStateLoading
                          ? CustomBoldText(
                              title: 'Update',
                              size: 23,
                              background: secondaryColor)
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(IconBroken.Notification)),
                ],
                title: CustomBoldText(
                    title: cubit.title[cubit.currentIndex],
                    size: 24,
                    background: myBlackColor)),
            body: state is! GetUserDataStateLoading
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 35),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      margin: const EdgeInsets.all(0),
                                      child: Image(
                                        image: cubit.coverImage == null
                                            ? NetworkImage(
                                                cubit.userModel?.coverImage ??
                                                    '')
                                            : FileImage(
                                                cubit.coverImage ?? File('')),
                                        fit: BoxFit.fill,
                                        height: 200,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: secondaryColor
                                                  .withOpacity(.9),
                                              borderRadius:
                                                  BorderRadius.circular(23)),
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () {
                                                  cubit.getCoverImage();
                                                },
                                                icon: Icon(
                                                  IconBroken.Camera,
                                                  color: primaryColor,
                                                  size: 30,
                                                )),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CircleAvatar(
                                      radius: 43,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 40,
                                        foregroundImage: cubit.profileImage ==
                                                null
                                            ? NetworkImage(
                                                cubit.userModel?.profileImage ??
                                                    '')
                                            : FileImage(
                                                cubit.profileImage ?? File('')),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, right: 5),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: secondaryColor
                                                  .withOpacity(.9),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () {
                                                  cubit.getProfileImage();
                                                },
                                                icon: Icon(
                                                  IconBroken.Camera,
                                                  color: primaryColor,
                                                )),
                                          ),
                                        )),
                                  ]),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: secondaryColor.withOpacity(.1),
                            ),
                            width: double.infinity,
                            height: 75,
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    children: [
                                      CustomProfileContainer('Posts', '0'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      CustomProfileContainer('Share', '0'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      CustomProfileContainer('Likes', '0'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      CustomProfileContainer('Comment', '0'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultFormField(
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              label: 'Name',
                              prefixIcon: IconBroken.User,
                              borderColor: secondaryColor,
                              iconColor: secondaryColor,
                              labelColor: secondaryColor),
                          const SizedBox(
                            height: 30,
                          ),
                          defaultFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.name,
                              label: 'Phone',
                              prefixIcon: IconBroken.Call,
                              borderColor: secondaryColor,
                              iconColor: secondaryColor,
                              labelColor: secondaryColor),
                          const SizedBox(
                            height: 30,
                          ),
                          defaultFormField(
                              controller: bioController,
                              keyboardType: TextInputType.text,
                              label: 'bio',
                              prefixIcon: IconBroken.Document,
                              borderColor: secondaryColor,
                              iconColor: secondaryColor,
                              labelColor: secondaryColor),
                        ],
                      ),
                    ),
                  )
                : state is! GetUserChatsErrorState
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
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
