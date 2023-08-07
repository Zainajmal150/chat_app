class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.isOnline,
    required this.lastActive,
    required this.id,
    required this.createAt,
    required this.email,
    required this.pushToken,
  });
  late  String image;
  late  String about;
  late  String name;
  late  bool isOnline;
  late  String lastActive;
  late  String id;
  late  String createAt;
  late  String email;
  late  String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? "";
    about = json['about'] ?? "";
    name = json['name'] ?? "";
    isOnline = json['is_online'] ?? "";
    lastActive = json['last_active'] ?? "";
    id = json['id'] ?? "";
    createAt = json['create_at'] ?? "";
    email = json['email'] ?? "";
    pushToken = json['push_token'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['id'] = id;
    data['create_at'] = createAt;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
