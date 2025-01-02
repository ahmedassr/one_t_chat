class MassageModel {
  String? text;
  String? dateTime;
  String? senderId;

  MassageModel(
      {required this.text, required this.dateTime, required this.senderId});

  MassageModel.fromJson(Map<String, dynamic> json) {
    text = json['text'] ?? '';
    dateTime = json['dateTime'] ?? '';
    senderId = json['senderId'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {'text': text, 'dateTime': dateTime, 'senderId': senderId};
  }
}
