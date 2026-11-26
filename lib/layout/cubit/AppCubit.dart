import 'dart:convert';
import 'dart:io';
import 'dart:async';

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
import 'package:one_t_chat/modules/setting_screen/ProfileScreen.dart';
import 'package:one_t_chat/modules/users_screen/AllUsersScreen.dart';
import 'package:one_t_chat/network/remote/DioHelper.dart';
import 'package:one_t_chat/shared/components/Components.dart';
import 'package:one_t_chat/shared/firebase/CustomFirebaseMessage.dart';

import '../../models/MassageModel.dart';
import '../../models/UserModel.dart';
import '../../shared/Constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  @override
  Future<void> close() async {
    await massagesSubscription?.cancel();
    await super.close();
  }

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screen = [
    FeedScreen(),
    ChatScreen(),
    PostScreen(),
    UsersScreen(),
    ProfileScreen()
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
    if (index == 0) {
      getPosts();
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
    if (uId.isEmpty) return;
    emit(GetUserDataStateLoading());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      if (!value.exists) {
        emit(GetUserDataStateError('User profile was not found.'));
        return;
      }
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
    if (this.profileImage != null) {
      await uploadProfileImage();
      profileImage = profileImageUrl ?? profileImage;
    }
    if (this.coverImage != null) {
      await uploadCoverImage();
      coverImage = coverImageUrl ?? coverImage;
    }
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
    if (postImage == null) {
      postImageUrl = null;
      return;
    }
    emit(UploadImagePostLoadingState());
    final bytes = await postImage!.readAsBytes();
    final base64Image = base64Encode(bytes);
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
    posts.clear();
    postsId.clear();
    likes.clear();
    comments.clear();
    try {
      final value = await FirebaseFirestore.instance
          .collection('post')
          .orderBy('dateTime', descending: true)
          .get();
      for (final post in value.docs) {
        final likeSnapshot = await post.reference.collection('like').get();
        final commentSnapshot =
            await post.reference.collection('comment').get();
        postsId.add(post.id);
        posts.add(PostModel.fromJson(post.data()));
        likes.add(likeSnapshot.docs.length);
        comments.add(commentSnapshot.docs.length);
      }
      emit(GetPostSuccessState());
    } catch (error) {
      emit(GetPostErrorState(error.toString()));
    }
  }

  Future<void> postLike(String postId) async {
    try {
      final likeRef = FirebaseFirestore.instance
          .collection('post')
          .doc(postId)
          .collection('like')
          .doc(uId);
      final snapshot = await likeRef.get();
      if (snapshot.exists) {
        await likeRef.delete();
      } else {
        await likeRef.set({'like': true});
      }
      emit(LikePostSuccessState());
    } catch (error) {
      emit(LikePostErrorState(error.toString()));
    }
  }

  Future<void> postComment(String postId, String comment) async {
    final trimmed = comment.trim();
    if (trimmed.isEmpty) return;
    try {
      await FirebaseFirestore.instance
          .collection('post')
          .doc(postId)
          .collection('comment')
          .add({
        'text': trimmed,
        'uId': uId,
        'dateTime': DateTime.now().toIso8601String()
      });
      emit(CommentPostSuccessState());
    } catch (error) {
      emit(CommentPostErrorState(error.toString()));
    }
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
    try {
      final value = await FirebaseFirestore.instance
          .collection('post')
          .doc(postId)
          .collection('comment')
          .get();
      for (final comment in value.docs) {
        final commentUserId = comment.data()['uId']?.toString() ?? comment.id;
        final user = await FirebaseFirestore.instance
            .collection('users')
            .doc(commentUserId)
            .get();
        commentBody?.add(comment.data()['text']?.toString() ?? '');
        if (user.data() != null) {
          usersCommentsPost?.add(UserModel.fromJson(user.data()));
        }
      }
      emit(GetPostCommentsSuccessState());
    } catch (error) {
      emit(GetPostCommentsErrorState(error.toString()));
    }
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
    final text = msg.trim();
    if (text.isEmpty || uId.isEmpty) return;
    MassageModel model = MassageModel(
        text: text, dateTime: DateTime.now().toIso8601String(), senderId: uId);
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

      if (accessToken.isEmpty) {
        accessToken = await CustomFirebaseMessage().getMyAccessToken() ?? '';
      }
      if (accessToken.isNotEmpty && receiverToken.isNotEmpty) {
        await postNotification(
            accessToken: accessToken,
            receiverToken: receiverToken,
            title: 'New message from ${userModel?.name ?? 'OneT Chat'}',
            body: text.length > 20 ? '${text.substring(0, 20)}...' : text);
      }
      emit(SendMassageSuccessState());
    } catch (error) {
      print(error.toString());
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
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? massagesSubscription;

  Future<void> getMassages({required String receiverId}) async {
    await massagesSubscription?.cancel();
    massages = [];
    massagesSubscription = FirebaseFirestore.instance
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
      });
      emit(GetMassageSuccessState());
    });
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
