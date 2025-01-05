import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:imgbb_uploader/imgbb.dart';
import 'package:imgbb_uploader/model/imgbb_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_t_chat/layout/cubit/AppStates.dart';
import 'package:one_t_chat/models/FcmNotificationModel.dart';
import 'package:one_t_chat/models/PostModel.dart';
import 'package:one_t_chat/modules/chat_screen/ChatScreen.dart';
import 'package:one_t_chat/modules/feed_screen/FeedScreen.dart';
import 'package:one_t_chat/modules/post_screen/PostScreen.dart';
import 'package:one_t_chat/modules/setting_screen/SettingScreen.dart';
import 'package:one_t_chat/modules/users_screen/AllUsersScreen.dart';
import 'package:one_t_chat/network/remote/DioHelper.dart';
import 'package:one_t_chat/shared/components/Components.dart';

import '../../models/MassageModel.dart';
import '../../models/UserModel.dart';
import '../../shared/Constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screen = [
    FeedScreen(),
    ChatScreen(),
    PostScreen(),
    UsersScreen(),
    SettingScreen()
  ];

  List<String> title = ['Feeds', 'Chats', 'Add Post', 'Users', 'Settings'];

  void navBarChangeIndex(index, context) {
    if (index == 2) {
      myNavigator(context, PostScreen(), backButton: true);
      emit(PostScreenOpenState());
    } else {
      currentIndex = index;
      emit(BottomNavBarChangedState());
    }
    if (index == 1) {
      getUserChats();
    }
    if (index == 3) {
      getUsers();
    }
    if (index == 4) {
      getUserData();
    }
  }

  UserModel? userModel;

  Future<void> getUserData() async {
    emit(GetUserDataStateLoading());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data());
      if (userModel != null) {
        emit(GetUserDataStateSuccess());
      }
    }).catchError((error) {
      emit(GetUserDataStateError(error.toString()));
    });
  }

  Future<void> updateUserData(
      {String? profileImage,
      String? coverImage,
      required String name,
      required String bio,
      required String phone}) async {
    emit(UpdateUserDataStateLoading());
    uploadProfileImage();
    uploadCoverImage();
    UserModel updateModel = UserModel(
        name: name,
        phone: phone,
        coverImage: coverImage ?? userModel?.coverImage,
        profileImage: profileImage ?? userModel?.profileImage,
        email: userModel?.email,
        uId: uId,
        bio: bio);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(updateModel.toMap())
        .then((value) {
      emit(UpdateUserDataStateSuccess());
    }).catchError((error) {
      emit(UpdateUserDataStateError(error.toString()));
    });
  }

  ImagePicker picker = ImagePicker();

  File? profileImage;
  String? profileImageUrl;

  Future<void> getProfileImage() async {
    emit(GetImageProfileLoadingState());
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        emit(GetImageProfileSuccessState());
      }
    } catch (error) {
      emit(GetImageProfileErrorState(error.toString()));
    }
  }

  Future<void> uploadProfileImage() async {
    if (profileImage != null) {
      try {
        final bytes = await profileImage?.readAsBytes();
        final base64Image = base64Encode(bytes!);
        await ImgbbUploader(imgbbApiKey)
            .uploadImageBase64(base64Image: base64Image)
            .then((value) {
          profileImageUrl = value?.data?.url;
        });
        print('######profile image url $profileImageUrl');
        emit(UploadImageProfileSuccessState());
      } catch (error) {
        emit(UploadImageProfileErrorState(error.toString()));
      }
    }
  }

  File? coverImage;
  String? coverImageUrl;

  Future<void> getCoverImage() async {
    emit(GetImageCoverLoadingState());
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        coverImage = File(pickedFile.path);
        emit(GetImageCoverSuccessState());
      }
    } catch (error) {
      emit(GetImageCoverErrorState(error.toString()));
    }
  }

  Future<void> uploadCoverImage() async {
    if (coverImage != null) {
      try {
        final bytes = await coverImage?.readAsBytes();
        final base64Image = base64Encode(bytes!);
        await ImgbbUploader(imgbbApiKey)
            .uploadImageBase64(base64Image: base64Image)
            .then((value) {
          coverImageUrl = value?.data?.url;
        });
        print('######cover image url $coverImageUrl');
        emit(UploadImageCoverSuccessState());
      } catch (error) {
        emit(UploadImageCoverErrorState(error.toString()));
      }
    }
  }

  File? postImage;
  String? postImageUrl;

  Future<void> getPostImage() async {
    emit(GetImagePostLoadingState());
    try {
      final pikedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pikedFile != null) {
        postImage = File(pikedFile.path);
        emit(GetImagePostSuccessState());
      }
    } catch (error) {
      emit(GetImagePostErrorState(error.toString()));
    }
  }

  Future<void> uploadPostImage() async {
    emit(UploadImagePostLoadingState());
    final bytes = await postImage?.readAsBytes();
    final base64Image = base64Encode(bytes!);
    await ImgbbUploader(imgbbApiKey)
        .uploadImageBase64(base64Image: base64Image)
        .then((value) {
      postImageUrl = value?.data?.url;
      print("$postImageUrl");
      emit(UploadImagePostSuccessState());
    }).catchError((error) {
      emit(UploadImagePostErrorState(error.toString()));
    });
  }

  Future<void> createPost(
      {required name,
      required profileImage,
      required String uId,
      required String dateTime,
      required String postText,
      String? postImage}) async {
    emit(CreatePostLoadingState());
    try {
      PostModel postModel = PostModel(
          name: name,
          profileImage: profileImage,
          uId: uId,
          dateTime: dateTime,
          postText: postText,
          postImage: postImage ?? '');

      await FirebaseFirestore.instance
          .collection('post')
          .add(postModel.toMap())
          .then((value) {
        emit(CreatePostSuccessState());
      });
    } catch (error) {
      emit(CreatePostErrorState(error.toString()));
    }
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> comments = [];

  Future<void> getPosts() async {
    emit(GetPostLoadingState());
    await FirebaseFirestore.instance.collection('post').get().then((value) {
      value.docs.forEach((e) async {
        try {
          final likeFuture = e.reference.collection('like').get();
          final commentFuture = e.reference.collection('comment').get();
          final result = await Future.wait([likeFuture, commentFuture]);
          final likeSnapshot = result[0];
          final commentSnapshot = result[1];
          postsId.add(e.id);
          posts.add(PostModel.fromJson(e.data()));
          likes.add(likeSnapshot.docs.length);
          comments.add(commentSnapshot.docs.length);
          emit(GetPostSuccessState());
        } catch (error) {
          emit(GetPostErrorState(error.toString()));
        }
      });
    }).catchError((error) {
      emit(GetPostErrorState(error.toString()));
    });
  }

  Future<void> postLike(String postId) async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(postId)
        .collection('like')
        .doc(userModel?.uId)
        .set({'like': true}).then((value) {
      emit(LikePostSuccessState());
    }).catchError((error) {
      emit(LikePostErrorState(error.toString()));
    });
  }

  Future<void> postComment(String postId, String comment) async {
    FirebaseFirestore.instance
        .collection('post')
        .doc(postId)
        .collection('comment')
        .doc(userModel?.uId)
        .set({'text': comment}).then((value) {
      emit(CommentPostSuccessState());
    }).catchError((error) {
      emit(CommentPostErrorState(error.toString()));
    });
  }

  List<UserModel>? usersLikePost;

  Future<void> getPostLikes(String postId) async {
    emit(GetPostLikesLoadingState());
    usersLikePost = [];
    await FirebaseFirestore.instance
        .collection('post')
        .doc(postId)
        .collection('like')
        .get()
        .then((value) {
      value.docs.forEach((e) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(e.id)
            .get()
            .then((value) {
          usersLikePost?.add(UserModel.fromJson(value.data()));
          emit(GetPostLikesSuccessState());
        }).catchError((error) {
          emit(GetPostLikesErrorState(error.toString()));
        });
      });
    }).catchError((error) {
      emit(GetPostLikesErrorState(error));
    });
  }

  List<UserModel>? usersCommentsPost;
  List<String>? commentBody;

  Future<void> getPostComments(String postId) async {
    emit(GetPostCommentsLoadingState());
    usersCommentsPost = [];
    commentBody = [];
    await FirebaseFirestore.instance
        .collection('post')
        .doc(postId)
        .collection('comment')
        .get()
        .then((value) {
      value.docs.forEach((e) async {
        commentBody?.add(e.get('text'));
        await FirebaseFirestore.instance
            .collection('users')
            .doc(e.id)
            .get()
            .then((value) {
          print('${value.data()}');
          usersCommentsPost?.add(UserModel.fromJson(value.data()));
          print('${value.data()}');
          emit(GetPostCommentsSuccessState());
        }).catchError((error) {
          emit(GetPostCommentsErrorState(error.toString()));
        });
      });
    }).catchError((error) {
      emit(GetPostLikesErrorState(error));
    });
  }

  List<UserModel> users = [];

  Future<void> getUsers() async {
    if (users.isEmpty) {
      emit(GetUsersLoadingState());
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((e) {
          if (e.id != uId) {
            users.add(UserModel.fromJson(e.data()));
          }
        });
        emit(GetUsersSuccessState());
      }).catchError((error) {
        emit(GetUsersErrorState(error.toString()));
      });
    }
  }

  Future<void> sendMassage(
      {required String receiverUid,
      required String receiverToken,
      required String msg}) async {
    MassageModel model = MassageModel(
        text: msg, dateTime: DateTime.now().toString(), senderId: uId);
    var token =
        await FirebaseMessaging.instance.getToken(vapidKey: receiverUid);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chat')
          .doc(receiverUid)
          .collection('massage')
          .doc()
          .set(model.toMap())
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .collection('chat')
            .doc(receiverUid)
            .set({'chat': true});
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUid)
          .collection('chat')
          .doc(uId)
          .collection('massage')
          .doc()
          .set(model.toMap())
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(receiverUid)
            .collection('chat')
            .doc(uId)
            .set({
          'chat': true,
        });
      });

      postNotification(
          accessToken: accessToken,
          receiverToken: receiverToken,
          title: 'you have a message from ${userModel?.name}',
          body: msg.length > 20
              ? '${msg.substring(0, 20)}...'
              : msg.substring(0, 20));

      emit(SendMassageSuccessState());
    } catch (error) {
      emit(SendMassageErrorState(error.toString()));
    }
  }

  List<UserModel> userChats = [];

  Future<void> getUserChats() async {
    userChats.clear();
    emit(GetUserChatsLoadingState());
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chat')
          .get();

      List<Future<void>> futures = querySnapshot.docs.map((doc) async {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .get();
        print('@@@@@@@${doc.id}');
        if (userSnapshot.data() != null) {
          print('@@@@@@@${userSnapshot.data()}');
          userChats.add(UserModel.fromJson(userSnapshot.data()));
        }
      }).toList();
      await Future.wait(futures);
      emit(GetUserChatsSuccessState());
    } catch (e) {
      emit(GetUserChatsErrorState(e.toString()));
    }
  }

  List<MassageModel>? massages;

  Future<void> getMassages({required String receiverId}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chat')
        .doc(receiverId)
        .collection('massage')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      massages = [];

      event.docs.forEach((e) {
        massages?.add(MassageModel.fromJson(e.data()));
        print('${e.data()}');
      });
      emit(GetMassageSuccessState());
    });

    //     .get()
    //     .then((value) {
    //   value.docs.forEach((e) {
    //     massages.add(MassageModel.fromJson(e.data()));
    //   });
    // }).catchError((error) {});
  }

  Future<void> postNotification(
      {required String accessToken,
      required String receiverToken,
      required String title,
      String? body}) async {
    FcmNotificationModel notificationModel = FcmNotificationModel(
        token: receiverToken,
        notification: NotificationDetails(title: title, body: body));
    await DioHelper.postDate(accessToken, notificationModel.toMap())
        .then((value) {
      print('successssssssssssss');
      emit(SendNotificationSuccessState());
    }).catchError((error) {
      print('Errorrrrrrrrrrrrr$error');
      emit(SendNotificationErrorState(error.toString()));
    });
  }
}
