bool? isNewUser = true;
String uId = '';
String accessToken = '';
// Passed at build time: flutter run --dart-define=IMGBB_API_KEY=your_key
const String imgbbApiKey = String.fromEnvironment('IMGBB_API_KEY');