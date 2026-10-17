class User {
  int? id;
  String name;
  String email;
  String passwordHash;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    passwordHash: json['password_hash'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'password_hash': passwordHash,
  };
}
