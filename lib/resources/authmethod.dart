import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:theklicks/models/user.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<Usermodel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return Usermodel.fromSnap(documentSnapshot);
  }
}
