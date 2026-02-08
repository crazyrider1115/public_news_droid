class UserModel {
  String name;
  String username;
  String password;
  bool approved;

  UserModel({
    required this.name,
    required this.username,
    required this.password,
    this.approved = false,
  });
}
