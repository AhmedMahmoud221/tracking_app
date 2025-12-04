class SignupResponseModel {
  final String status;
  final String token;
  final UserData data;

  SignupResponseModel({
    required this.status,
    required this.token,
    required this.data,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      status: json['status'],
      token: json['token'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'token': token,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final User user;

  UserData({required this.user});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson()};
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final bool active;
  final String role;
  final bool isVerified;
  final int v;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.active,
    required this.role,
    required this.isVerified,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      active: json['active'],
      role: json['role'],
      isVerified: json['isVerified'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'active': active,
      'role': role,
      'isVerified': isVerified,
      '__v': v,
    };
  }
}
