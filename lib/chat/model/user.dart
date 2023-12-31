class UserModel {
  final String uid;
  final String name;
  final String email;

  final DateTime lastActive;
  final bool isOnline;

  const UserModel({
    required this.name,
    required this.lastActive,
    required this.uid,
    required this.email,
    this.isOnline = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        isOnline: json['isOnline'] ?? false,
        lastActive: json['lastActive'].toDate(),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'isOnline': isOnline,
        'lastActive': lastActive,
      };
}
