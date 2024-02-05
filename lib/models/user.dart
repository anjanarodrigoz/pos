enum UserRole {
  admin,
  user,
}

class User {
  String username;
  String password;
  UserRole role;

  User({required this.username, required this.password, required this.role});

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'role': role.toString().split('.').last, // Convert enum to string
    };
  }

  // Create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      role: UserRole.values
          .firstWhere((e) => e.toString().split('.').last == json['role']),
    );
  }
}
