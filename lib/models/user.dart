class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'profileImage': profileImage,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      profileImage: json['profileImage'],
    );
  }
}