class Profile {
  String id;
  String firstName;
  String lastName;
  String email;
  String? profileImageUrl;
  String? tokenId;
  bool passwordExists;
  bool emailVerified;

  Profile(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.tokenId,
      this.passwordExists = false,
      this.emailVerified = false,
      this.profileImageUrl});

  static Profile fromJson(Map<String, dynamic> json) {
    return Profile(
        id: json['id'] ?? json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        profileImageUrl: json['profileImage'],
        tokenId: json['tokenId'],
        passwordExists: json['passwordExists'] ?? false,
        emailVerified: json['emailVerified'] ?? false);
  }
}
