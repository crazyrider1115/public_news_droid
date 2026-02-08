import '../models/user_model.dart';

class AuthService {
  static final List<UserModel> _users = [];

  // SIGN UP
  static String signUp(String name, String username, String password) {
    final exists = _users.any((u) => u.username == username);
    if (exists) {
      return "User already exists";
    }

    _users.add(
      UserModel(
        name: name,
        username: username,
        password: password,
        approved: false,
      ),
    );

    return "Signup successful. Wait for admin approval";
  }

  // SIGN IN
  static String signIn(String username, String password) {
    try {
      final user = _users.firstWhere(
        (u) => u.username == username && u.password == password,
      );

      if (!user.approved) {
        return "Account not approved yet";
      }

      return "Login success";
    } catch (e) {
      return "Invalid username or password";
    }
  }

  // ADMIN
  static List<UserModel> getPendingUsers() {
    return _users.where((u) => !u.approved).toList();
  }

  static void approveUser(UserModel user) {
    user.approved = true;
  }
}
