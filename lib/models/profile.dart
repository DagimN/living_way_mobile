class Profile {
  String firstName;
  String lastName;
  String? imageUrl;

  Profile(
      {required this.firstName,
      required this.lastName,
      this.imageUrl});
}