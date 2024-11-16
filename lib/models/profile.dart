class Profile {
  String id;
  String firstName;
  String lastName;
  String? profileImageUrl;
  bool isAnonymous;

  Profile(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.isAnonymous = true,
      this.profileImageUrl});

  static Profile fromJson(Map<String, dynamic> json) {
    return Profile(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        profileImageUrl: json['profileImage'],
        isAnonymous: json['isAnonymous']);
  }
}
