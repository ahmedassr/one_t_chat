import 'package:flutter_test/flutter_test.dart';

import 'package:one_t_chat/models/MassageModel.dart';
import 'package:one_t_chat/models/PostModel.dart';
import 'package:one_t_chat/models/UserModel.dart';
import 'package:one_t_chat/shared/ErrorHandler.dart';

void main() {
  test('PostModel reads dateTime correctly', () {
    final model = PostModel.fromJson({
      'name': 'Ahmed',
      'dateTime': '2026-11-26T10:00:00.000',
      'postText': 'Hello',
      'postImage': '',
    });

    expect(model.name, 'Ahmed');
    expect(model.dateTime, '2026-11-26T10:00:00.000');
  });

  test('UserModel defaults missing fields safely', () {
    final model = UserModel.fromJson(null);

    expect(model.name, '');
    expect(model.email, '');
    expect(model.profileImage, '');
  });

  test('MassageModel serializes and deserializes', () {
    final model = MassageModel(
      text: 'Hi',
      dateTime: '2026-11-26T10:00:00.000',
      senderId: 'user-1',
    );

    expect(MassageModel.fromJson(model.toMap()).text, 'Hi');
  });

  test('Friendly auth errors are mapped', () {
    expect(
      ErrorHandler.getFriendlyErrorMessage('invalid-email'),
      'البريد الاكتروني غير صحيح',
    );
    expect(
      ErrorHandler.getFriendlyErrorMessage('network-request-failed'),
      isNotEmpty,
    );
  });
}
