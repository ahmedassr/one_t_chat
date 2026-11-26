# Improvement Report

## Bugs Fixed

- Fixed post timestamp deserialization.
- Fixed text-only publishing and guarded empty posts.
- Fixed comment storage to append records and resolve users by stored `uId`.
- Fixed like behavior to toggle a user's like.
- Fixed profile uploads to await ImgBB before updating Firestore.
- Fixed chat stream lifecycle and message timestamp parsing.
- Fixed short-message notification preview bounds.
- Removed startup failure from missing FCM service-account configuration.
- Fixed Dio notification failures to throw on unsuccessful HTTP responses.
- Replaced the feed's endless loading state with loading, error, empty, and
  pull-to-refresh states.

## Functional Improvements

- Posts can now be published with text or an image.
- Comments are trimmed and reject empty submissions.
- Likes are toggled rather than unconditionally repeated.
- Chat notification setup is attempted only when a token is available.
- Post/comment user lookups preserve null safety.

## UI/UX Improvements

- Added a centralized Material 3 theme and modern card/input styles.
- Replaced the bottom navigation with `NavigationBar`.
- Simplified app-bar titles and removed placeholder navigation actions.
- Added feed pull-to-refresh, loading, empty, and retry states.
- Improved feed list spacing and use of full-width cards.

## Files Modified

Main implementation areas include:

- `lib/layout/cubit/AppCubit.dart`
- `lib/layout/HomeLayout.dart`
- `lib/main.dart`
- `lib/models/PostModel.dart`
- `lib/modules/feed_screen/FeedScreen.dart`
- `lib/modules/post_screen/PostScreen.dart`
- `lib/modules/chat_screen/ChatDetailsScreen.dart`
- `lib/shared/firebase/CustomFirebaseMessage.dart`
- `lib/network/remote/DioHelper.dart`
- `lib/shared/style/color.dart`
- `test/widget_test.dart`

## Verification

- `dart format .`: completed.
- `flutter test --no-pub`: 4 tests passed.
- `flutter analyze --no-pub`: no analyzer errors found; existing info/warning
  lint debt remains (imports, naming, print/debug, deprecations).
- `flutter build apk --debug --no-pub`: could not complete within the verification
  window; Gradle remained on the Android `assembleDebug` task and was stopped.

## Remaining Issues

- FCM credential signing is still client-side and must move to a backend for
  production use.
- The app needs Firestore Security Rules and server-side validation.
- Full emulator/device and screenshot verification could not replace static
  analysis where Firebase services or credentials were unavailable.
- Pagination, profile statistics, notification center, search, and deleted/
  edited post features remain outside the existing implementation.
