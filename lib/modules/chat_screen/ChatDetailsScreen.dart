import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:one_t_chat/layout/cubit/AppCubit.dart';
import 'package:one_t_chat/layout/cubit/AppStates.dart';
import 'package:one_t_chat/models/MassageModel.dart';
import 'package:one_t_chat/shared/components/Components.dart';

import '../../shared/Constants.dart';
import '../../shared/style/color.dart';
import '../../shared/style/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  final String name;
  final String image;
  final String receiverUid;
  final String receiverToken;

  ChatDetailsScreen(
      {super.key,
      required this.name,
      required this.image,
      required this.receiverUid,
      required this.receiverToken});

  @override
  Widget build(BuildContext context) {
    var msgController = TextEditingController();
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    foregroundImage: NetworkImage(image ?? ''),
                    backgroundColor: secondaryColor.withOpacity(.5),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomBoldText(
                      title: name, size: 20, background: myBlackColor),
                ],
              ),
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          MassageModel? model = cubit.massages?[index];
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: model?.senderId == uId
                                ? senderMassage(
                                    msg: model?.text ?? '',
                                    time: model?.dateTime ?? '0-0')
                                : receiverMassage(
                                    msg: model?.text ?? '',
                                    time: model?.dateTime ?? '0-0'),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                        itemCount: cubit.massages?.length ?? 0)),
                Card(
                  color: primaryColor.withOpacity(.5),
                  child: Row(
                    children: [
                      Expanded(
                        child: defaultFormField(
                            controller: msgController,
                            keyboardType: TextInputType.name,
                            label: 'Massage',
                            prefixIcon: IconBroken.Chat,
                            iconColor: myBlackColor),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: msgController != ''
                              ? IconButton(
                                  onPressed: () {
                                    if (msgController.text != '') {
                                      cubit.sendMassage(
                                          receiverUid: receiverUid,
                                          msg: msgController.text,
                                          receiverToken: receiverToken);
                                      msgController.clear();
                                    }
                                  },
                                  icon: Icon(
                                    IconBroken.Send,
                                    color: secondaryColor,
                                  ))
                              : Icon(
                                  IconBroken.Send,
                                  color: secondaryColor.withOpacity(.7),
                                )),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        listener: (context, state) {});
  }
}

Widget senderMassage({required String msg, required String time}) {
  DateTime dateTime = DateTime.parse(time);
  String formatTime = DateFormat('HH:mm').format(dateTime);
  return Align(
    alignment: Alignment.bottomRight,
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: OverflowBar(
              children: [
                CustomBoldText(title: msg, size: 18, background: myBlackColor),
                const SizedBox(
                  width: 5,
                ),
                CustomBoldText(
                    title: formatTime, size: 12, background: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget receiverMassage({required String msg, required String time}) {
  DateTime dateTime = DateTime.parse(time);
  String formatTime = DateFormat('HH:mm').format(dateTime);
  return Align(
    alignment: Alignment.bottomLeft,
    child: Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: OverflowBar(
              children: [
                CustomBoldText(title: msg, size: 18, background: myBlackColor),
                const SizedBox(
                  width: 5,
                ),
                CustomBoldText(
                    title: formatTime, size: 12, background: Colors.white),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
