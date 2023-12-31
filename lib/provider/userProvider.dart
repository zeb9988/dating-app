import 'package:flutter/widgets.dart';
import 'package:theklicks/models/user.dart';
import 'package:theklicks/resources/authmethod.dart';

class UserProvider with ChangeNotifier {
  Usermodel? _user;
  final AuthMethods _authMethods = AuthMethods();

  Usermodel get user => _user!;

  Future<void> refreshUser() async {
    Usermodel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
