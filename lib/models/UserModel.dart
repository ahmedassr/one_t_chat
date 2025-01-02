class UserModel {
  String? email;
  String? name;
  String? phone;
  String? uId;
  String? profileImage;
  String? coverImage;
  String? bio;
  String? token;

  UserModel({
    this.name,
    this.phone,
    this.coverImage,
    this.profileImage,
    this.email,
    this.uId,
    this.bio,
    this.token,
  });

  UserModel.fromJson(Map<String, dynamic>? json) {
    email = json?['email'] ?? '';
    name = json?['name'] ?? '';
    phone = json?['phone'] ?? '';
    uId = json?['uId'] ?? '';
    coverImage = json?['coverImage'] ?? '';
    profileImage = json?['profileImage'] ?? '';
    bio = json?['bio'] ?? '';
    token = json?['token'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'uId': uId,
      'coverImage': coverImage,
      'profileImage': profileImage,
      'bio': bio,
      'token': token ?? '',
    };
  }
}
