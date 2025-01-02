import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_t_chat/layout/cubit/AppCubit.dart';
import 'package:one_t_chat/modules/chat_screen/ChatDetailsScreen.dart';
import 'package:one_t_chat/shared/components/Components.dart';
import 'package:one_t_chat/shared/components/CustomChatCard.dart';
import 'package:one_t_chat/shared/style/color.dart';
import 'package:one_t_chat/shared/style/icon_broken.dart';

import '../../layout/cubit/AppStates.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Scaffold(
            body: state is! GetUserChatsLoadingState
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: cubit.userChats.isNotEmpty
                        ? ListView.separated(
                            itemBuilder: (context, index) {
                              var model = cubit.userChats[index];
                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    foregroundImage:
                                        NetworkImage(model.profileImage ?? ''),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomBoldText(
                                      title: model.name ?? '',
                                      size: 20,
                                      background: myBlackColor),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        cubit.getMassages(
                                            receiverId: model.uId ?? '');
                                        myNavigator(
                                            backButton: true,
                                            context,
                                            ChatDetailsScreen(
                                              name: model.name ?? '',
                                              image: model.profileImage ?? '',
                                              receiverUid: model.uId ?? '',
                                              receiverToken: model.token ?? '',
                                            ));
                                      },
                                      icon: Icon(
                                        IconBroken.Arrow___Right_2,
                                        size: 33,
                                        color: secondaryColor.withOpacity(.9),
                                      ))
                                ],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: cubit.userChats.length)
                        : Center(
                            child: CustomBoldText(
                                title:
                                    '''you don\'t have any chat yet try to chat with your friends with 
                                                             OneT Chat''',
                                size: 24,
                                background: secondaryColor),
                          ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        },
        listener: (context, state) {});
  }
}
