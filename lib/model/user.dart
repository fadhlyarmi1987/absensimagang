class User {
  String name;
  String email;
  String password;
  String userType;

  User({required this.name, required this.email, required this.password, required this.userType});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'user_type': userType,
    };
  }
}
