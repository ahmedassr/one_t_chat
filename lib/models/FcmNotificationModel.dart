class FcmNotificationModel {
  String? token;
  NotificationDetails? notification;

  FcmNotificationModel({this.token, this.notification});

  // Factory method to create an instance from JSON
  FcmNotificationModel.fromJson(Map<String, dynamic> json) {
    token = json['message']['token'];
    notification = json['message']['notification'] != null
        ? NotificationDetails.fromJson(json['message']['notification'])
        : null;
  }

  // Method to convert the object to a map (for sending as JSON)
  Map<String, dynamic> toMap() {
    return {
      'message': {
        'token': token,
        'notification': notification?.toMap(),
      },
    };
  }
}

class NotificationDetails {
  String? title;
  String? body;

  NotificationDetails({this.title, this.body});

  // Factory method to create an instance from JSON
  NotificationDetails.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  // Method to convert the object to a map (for sending as JSON)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }
}
