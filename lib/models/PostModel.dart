class PostModel {
  String? name;
  String? profileImage;
  String? uId;
  String? dateTime;
  String? postText;
  String? postImage;

  PostModel({this.name, this.profileImage, this.uId, this.dateTime,
      this.postText, this.postImage});

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    profileImage = json['profileImage'] ?? '';
    uId = json['uId'] ?? '';
    dateTime = json['dataTime'] ?? '';
    postText = json['postText'] ?? '';
    postImage = json['postImage'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profileImage': profileImage,
      'uId': uId,
      'dateTime': dateTime,
      'postText' : postText,
      'postImage': postImage,
    };
  }
}
