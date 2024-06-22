class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.joinDate,
    required this.username,
    required this.avatarURL,
    required this.listLanguage,
    required this.listInterest,
  });

  String? id;
  String? email;
  Object? joinDate;
  final String? username;
  final String? avatarURL;
  final List<dynamic>? listLanguage;
  final List<dynamic>? listInterest;
}