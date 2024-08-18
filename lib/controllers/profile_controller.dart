import "package:flutter/material.dart";
import "package:living_way/models/profile.dart";

class ProfileController extends ChangeNotifier {
  Profile? userProfile;

  set setUserProfile(Profile value) {
    userProfile;
    notifyListeners();
  }
}
