class User {
  int? id;
  String name;
  String email;
  String passwordHash;
  String? profileImage;
  static const String defaultUnknownImage = "unknown_image.jpg";

  User({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.profileImage,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    passwordHash: json['password_hash'],
    profileImage: json['profile_image'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'password_hash': passwordHash,
    'profile_image': profileImage,
  };
}
