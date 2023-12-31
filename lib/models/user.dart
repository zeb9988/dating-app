import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  final String uid;
  final String email;
  final String profileImageUrl;
  final String username;
  final String bio;
  final String gender;
  final String single;
  final List<String> likedPeople;
  final List<String> likedBack; // Added field for liked back users

  Usermodel({
    required this.uid,
    required this.profileImageUrl,
    required this.gender,
    required this.single,
    required this.username,
    required this.email,
    required this.bio,
    required this.likedPeople,
    required this.likedBack,
  });

  factory Usermodel.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    print('Firestore Snapshot: $snapshot');
    // Handle 'likedPeople' and 'likedBack' fields
    List<String> likedPeople = List<String>.from(snapshot["likedPeople"] ?? []);
    List<String> likedBack = List<String>.from(snapshot["likedBack"] ?? []);

    return Usermodel(
      username: snapshot["username"] ?? '',
      uid: snapshot["uid"] ?? '',
      email: snapshot["Email"] ?? '',
      profileImageUrl: snapshot["profileImageUrl"] ?? '',
      bio: snapshot["bio"] ?? '',
      gender: snapshot["gender"] ?? '',
      single: snapshot["single"] ?? '',
      likedPeople: likedPeople,
      likedBack: likedBack,
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "Email": email,
        "profileImageUrl": profileImageUrl,
        "bio": bio,
        "gender": gender,
        "single": single,
        "likedPeople": likedPeople,
        "likedBack": likedBack,
      };
}
