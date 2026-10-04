import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';

import '../Constants.dart';

class CustomFirebaseMessage {
  /// Path of the local service-account file used to sign FCM v1 requests.
  /// The real file is git-ignored; see README > Setup.
  static const String serviceAccountAsset =
      'assets/secrets/service_account.json';

  Future<String> getAccessToken() async {
    final String serviceAccountJson =
        await rootBundle.loadString(serviceAccountAsset);
    final Map<String, dynamic> serviceAccountMap =
        jsonDecode(serviceAccountJson) as Map<String, dynamic>;
    final accountCredentials =
        ServiceAccountCredentials.fromJson(serviceAccountMap);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await clientViaServiceAccount(accountCredentials, scopes);
    return client.credentials.accessToken.data;
  }

  Future<void> saveUserToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set({'token': token}, SetOptions(merge: true))
        .then((value) {})
        .catchError((error) {});
  }

  Future<String?> getMyAccessToken() async {
    try {
      FirebaseMessaging.instance.requestPermission();
      CustomFirebaseMessage customFirebaseMessage = CustomFirebaseMessage();
      String accessToken = await customFirebaseMessage.getAccessToken();
      return accessToken;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
