import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/layout/cubit/AppCubit.dart';
import 'package:one_t_chat/layout/cubit/AppStates.dart';
import 'package:one_t_chat/modules/chat_screen/ChatDetailsScreen.dart';
import 'package:one_t_chat/shared/components/Components.dart';

import '../../models/UserModel.dart';
import '../style/color.dart';
import '../style/icon_broken.dart';

class CustomChatCard extends StatelessWidget {
  final UserModel model;

  CustomChatCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Card(
            color: primaryColor.withOpacity(.87),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  foregroundImage: NetworkImage(model.profileImage ?? ''),
                  backgroundColor: secondaryColor.withOpacity(.5),
                ),
                const SizedBox(
                  height: 10,
                ),
                OverflowBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    CustomBoldText(
                        title: model.name ?? '',
                        size: 18,
                        background: myBlackColor,
                        maxLines: 2),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          AppCubit.get(context).getMassages(receiverId: model.uId ?? '');
                          myNavigator(
                              context,
                              ChatDetailsScreen(
                                  name: model.name ?? '',
                                  image: model.profileImage ?? '',
                                  receiverUid: model.uId ?? '',
                              receiverToken: model.token ?? '',),
                              backButton: true);
                        },
                        icon: Icon(
                          IconBroken.Send,
                          color: secondaryColor,
                        ))
                  ],
                )
              ],
            ),
          );
        },
        listener: (context, state) {});
  }
}
