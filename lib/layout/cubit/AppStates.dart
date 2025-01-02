abstract class AppStates {}

class AppInitialState extends AppStates {}

class NewUserGetStartedState extends AppStates {}

class BottomNavBarChangedState extends AppStates {}

class PostScreenOpenState extends AppStates {}

class GetUserDataStateLoading extends AppStates {}

class GetUserDataStateSuccess extends AppStates {}

class GetUserDataStateError extends AppStates {
  final String error;

  GetUserDataStateError(this.error);
}

class UpdateUserDataStateLoading extends AppStates {}

class UpdateUserDataStateSuccess extends AppStates {}

class UpdateUserDataStateError extends AppStates {
  final String error;

  UpdateUserDataStateError(this.error);
}

class GetImageProfileLoadingState extends AppStates {}

class GetImageProfileSuccessState extends AppStates {}

class GetImageProfileErrorState extends AppStates {
  final String error;

  GetImageProfileErrorState(this.error);
}

class GetImageCoverLoadingState extends AppStates {}

class GetImageCoverSuccessState extends AppStates {}

class GetImageCoverErrorState extends AppStates {
  final String error;

  GetImageCoverErrorState(this.error);
}

class UploadImageProfileSuccessState extends AppStates {}

class UploadImageProfileErrorState extends AppStates {
  final String error;

  UploadImageProfileErrorState(this.error);
}

class UploadImageCoverSuccessState extends AppStates {}

class UploadImageCoverErrorState extends AppStates {
  final String error;

  UploadImageCoverErrorState(this.error);
}

class GetImagePostLoadingState extends AppStates {}

class GetImagePostSuccessState extends AppStates {}

class GetImagePostErrorState extends AppStates {
  final String error;

  GetImagePostErrorState(this.error);
}

class UploadImagePostSuccessState extends AppStates {}

class UploadImagePostLoadingState extends AppStates {}

class UploadImagePostErrorState extends AppStates {
  final String error;

  UploadImagePostErrorState(this.error);
}

class CreatePostLoadingState extends AppStates {}

class CreatePostSuccessState extends AppStates {}

class CreatePostErrorState extends AppStates {
  final String error;

  CreatePostErrorState(this.error);
}

class GetPostLoadingState extends AppStates {}

class GetPostSuccessState extends AppStates {}

class GetPostErrorState extends AppStates {
  final String error;

  GetPostErrorState(this.error);
}

class LikePostSuccessState extends AppStates {}

class LikePostErrorState extends AppStates {
  final String error;

  LikePostErrorState(this.error);
}

class CommentPostSuccessState extends AppStates {}

class CommentPostErrorState extends AppStates {
  final String error;

  CommentPostErrorState(this.error);
}

class GetPostLikesLoadingState extends AppStates {}

class GetPostLikesSuccessState extends AppStates {}

class GetPostLikesErrorState extends AppStates {
  final String error;

  GetPostLikesErrorState(this.error);
}

class GetPostCommentsLoadingState extends AppStates {}

class GetPostCommentsSuccessState extends AppStates {}

class GetPostCommentsErrorState extends AppStates {
  final String error;

  GetPostCommentsErrorState(this.error);
}

class GetUsersLoadingState extends AppStates {}

class GetUsersSuccessState extends AppStates {}

class GetUsersErrorState extends AppStates {
  final String error;

  GetUsersErrorState(this.error);
}

class SendMassageSuccessState extends AppStates {}

class SendMassageErrorState extends AppStates {
  final String error;

  SendMassageErrorState(this.error);
}

class GetUserChatsLoadingState extends AppStates {}

class GetUserChatsSuccessState extends AppStates {}

class GetUserChatsEmptyState extends AppStates {}

class GetUserChatsErrorState extends AppStates {
  final String error;

  GetUserChatsErrorState(this.error);
}

class GetMassageSuccessState extends AppStates {}

class SendNotificationSuccessState extends AppStates {}

class SendNotificationErrorState extends AppStates {
  final String error;

  SendNotificationErrorState(this.error);
}
