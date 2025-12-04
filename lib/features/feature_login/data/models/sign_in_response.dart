class LoginResponseModel {
  final String status;
  final String token;
  final User user;

  LoginResponseModel({
    required this.status,
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'],
      token: json['token'],
      user: User.fromJson(json['data']['user']),
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final bool active;
  final String role;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.active,
    required this.role,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      active: json['active'],
      role: json['role'],
      isVerified: json['isVerified'],
    );
  }
}
