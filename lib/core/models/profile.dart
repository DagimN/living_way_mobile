class Profile {
  String id;
  String firstName;
  String lastName;
  String? profileImageUrl;
  String? tokenId;
  bool passwordExists;
  bool isAnonymous;

  Profile(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.isAnonymous = true,
      this.tokenId,
      this.passwordExists = false,
      this.profileImageUrl});

  static Profile fromJson(Map<String, dynamic> json) {
    return Profile(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        profileImageUrl: json['profileImage'],
        isAnonymous: json['isAnonymous'],
        tokenId: json['tokenId'],
        passwordExists: json['passwordExists'] ?? false);
  }
}
