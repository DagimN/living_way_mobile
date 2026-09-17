import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:living_way/core/models/resource/devotion.dart';

class Profile {
  String id;
  String firstName;
  String lastName;
  String email;
  String? phoneNumber;
  String? profileImageUrl;
  String? tokenId;
  bool passwordExists;
  bool emailVerified;
  String? address;
  LatLng? coordinates;
  List<Devotion> devotionProgress;

  Profile(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.tokenId,
      this.passwordExists = false,
      this.emailVerified = false,
      this.profileImageUrl,
      this.phoneNumber,
      this.address,
      this.coordinates,
      this.devotionProgress = const []});

  static Profile fromJson(Map<String, dynamic> json) {
    return Profile(
        id: json['id'] ?? json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        profileImageUrl: json['profileImage'],
        tokenId: json['tokenId'],
        passwordExists: json['passwordExists'] ?? false,
        emailVerified: json['emailVerified'] ?? false,
        phoneNumber: json['phoneNumber'],
        address: json['address'],
        coordinates: json['coordinates'] != null
            ? LatLng.fromJson(json['coordinates'])
            : null,
        devotionProgress: List.from(json['devotionProgress'] ?? [])
            .map((devotion) => Devotion.fromJson(devotion))
            .toList());
  }
}
