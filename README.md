# OneT Chat

A real-time social and chat app built with Flutter and Firebase. Users can publish posts with images, like and comment, browse other users, and chat one-to-one with instant push notifications.

I built this project to practice real-time systems and the BLoC/Cubit pattern, alongside the GetX-based apps I build professionally.

## Features

- **Authentication**: email and password sign-up and login with Firebase Authentication; the session is kept locally so returning users skip the login screen
- **Social feed**: create posts with text and images, sorted by newest first
- **Likes and comments**: like posts, add comments, and view who liked or commented
- **User directory**: browse all registered users and start a conversation
- **Real-time one-to-one chat**: messages stream live from Cloud Firestore snapshots
- **Push notifications**: a notification is sent to the receiver through Firebase Cloud Messaging (HTTP v1 API) when a new message arrives
- **Profile management**: edit name, bio, profile picture, and cover image
- **Image uploads via ImgBB**: images are hosted externally and only their URLs are stored, keeping Firestore documents small

## Tech Stack

| Area | Tools |
|---|---|
| Framework | Flutter, Dart |
| State management | flutter_bloc (Cubit), custom `BlocObserver` for state logging |
| Backend | Firebase Authentication, Cloud Firestore, Firebase Cloud Messaging |
| Networking | Dio (FCM HTTP v1), googleapis_auth (OAuth2 access tokens) |
| Storage | SharedPreferences (session), ImgBB API (images) |
| UI | Material, carousel_slider, image_picker, custom icon font |

## Architecture

The app uses a **feature-based structure** with Cubits:

- A global **`AppCubit`** holds shared state used across the main tabs: the current user, posts, users, chats, and messages.
- **Feature Cubits** (`LoginCubit`, `RegisterCubit`) own state that belongs to a single flow.
- Each Cubit exposes explicit **state classes**, and the UI rebuilds with `BlocConsumer` / `BlocBuilder`.
- Networking and local storage are wrapped in small helpers (`DioHelper`, `CashHelper`) so screens never call packages directly.

```
UI (screens & widgets)
   │  BlocBuilder / BlocConsumer
   ▼
Cubits (AppCubit, LoginCubit, RegisterCubit)
   │
   ├──► Firebase Auth / Cloud Firestore   (users, posts, chats, messages)
   ├──► ImgBB API                          (image hosting)
   ├──► DioHelper ──► FCM HTTP v1          (push notifications)
   └──► CashHelper ──► SharedPreferences   (session)
```

### Firestore data model

```
users/{uId}
  ├── name, email, phone, bio, profileImage, coverImage, token
  └── chat/{otherUId}/massage/{messageId}   # one-to-one messages, ordered by dateTime
post/{postId}
  ├── uId, name, profileImage, postText, postImage, dateTime
  ├── like/{uId}        # { like: true }
  └── comment/{uId}     # { text }
```

## Project Structure

```
lib/
├── layout/          # HomeLayout (bottom navigation) and AppCubit
├── modules/         # Feature screens: welcome, login, register, feed,
│                    # post, chat, users, profile
├── models/          # User, Post, Message, FCM notification models
├── network/
│   ├── remote/      # DioHelper (FCM requests)
│   └── local/       # CashHelper (SharedPreferences)
├── shared/
│   ├── components/  # Reusable widgets (post card, chat card, ...)
│   ├── firebase/    # FCM token and access-token handling
│   └── style/       # Colors, text, icons
└── main.dart
```

## Setup

1. **Clone and install dependencies**
   ```bash
   git clone https://github.com/ahmedassr/one_t_chat.git
   cd one_t_chat
   flutter pub get
   ```
2. **Connect your own Firebase project**: enable Email/Password Authentication, Cloud Firestore, and Cloud Messaging, then add your app config (`google-services.json` for Android, `GoogleService-Info.plist` for iOS), for example with `flutterfire configure`. Update the project ID in `lib/network/remote/DioHelper.dart`.
3. **Add a service account for FCM** (development only): copy `assets/secrets/service_account.example.json` to `assets/secrets/service_account.json` and fill it with a key from *Firebase Console → Project settings → Service accounts*. This file is git-ignored.
4. **Run with your ImgBB key**
   ```bash
   flutter run --dart-define=IMGBB_API_KEY=your_imgbb_key
   ```

## Security Note

Secrets are kept out of source control: the ImgBB key is injected at build time with `--dart-define`, and the service-account file is git-ignored.

Signing FCM requests from the client is acceptable for a learning project but **not for production**, because any credential shipped inside an app can be extracted. In production, notifications should be sent from a trusted backend, for example a Cloud Function triggered when a new message document is created.

## What I Would Improve Next

- Move notification sending to a Cloud Function
- Add a repository layer between Cubits and Firebase to make the logic testable
- Split `AppCubit` into smaller feature Cubits (feed, chat, profile)
- Add unit tests for Cubits and widget tests for key screens
- Add pagination for the feed and chat history

## Author

**Ahmed Al-Assar**, Mobile Application Developer (Flutter)
[Portfolio](https://ahmedalassar-portfolio.vercel.app) · [LinkedIn](https://www.linkedin.com/in/ahmed-alassar-840528259/) · [GitHub](https://github.com/ahmedassr)
