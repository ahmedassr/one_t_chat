# Project Audit

## Overview

OneT Chat is a Flutter/Firebase social chat application. It uses Cubits for state,
Firebase Authentication and Cloud Firestore for identity/data, ImgBB for media,
and Firebase Cloud Messaging for push notifications.

## Architecture

- Feature screens live under `lib/modules`.
- Shared application state is owned by `AppCubit`.
- Authentication flows have dedicated login/register Cubits.
- Firebase, SharedPreferences, HTTP, models, and reusable widgets are separated
  into the existing network/models/shared folders.

## Findings

### Critical

- `PostModel.fromJson` read `dataTime` instead of the stored `dateTime` field,
  so post timestamps were not available.
- Text-only posts were never created because publishing required an uploaded image.
- Comment writes reused one document per user, so later comments overwritten earlier
  comments instead of creating comment history.
- The chat stream subscription was never retained or cancelled, risking duplicate
  listeners and stale state.
- FCM notification setup used credentials on the client startup path and could fail
  startup when the optional service-account asset was missing.

### High

- Profile uploads were started without awaiting them, allowing Firestore updates
  to save stale image URLs.
- `getPosts` emitted interleaved states while asynchronous subqueries completed.
- Message preview used `substring(0, 20)` even for short messages and could throw.
- Chat sending passed `vapidKey: receiverUid`, which is not the sender's VAPID key.
- Missing or malformed Firestore profile/message timestamps could cause UI crashes.

### Medium

- Feed and chat screens lacked reliable empty/error states and pull-to-refresh.
- Posting, commenting, and liking did not consistently enforce valid/trimmed input.
- Login/register screens recreated mutable controllers as StatelessWidget fields.
- Production code contained extensive debug `print` statements.
- The UI used ad hoc colors, no centralized theme, and inconsistent navigation.

### Low

- Numerous duplicate/unnecessary imports and filename naming lint warnings remain.
- Deprecated `withOpacity` calls remain in some cards and screens.
- The template widget test did not test application behavior.

## Security Recommendations

- Move FCM HTTP v1 notification sending behind a trusted backend or Cloud Function.
- Add Firestore Security Rules; do not rely on client-side validation.
- Add Firebase Storage rules if storage is adopted in place of ImgBB.
- Rotate any credential that has previously been committed; the repository should
  keep no production secrets.
