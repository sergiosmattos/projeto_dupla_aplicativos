class ListProduct {
  int? id;
  String name;
  String description;
  int? userId;

  ListProduct({
    this.id,
    required this.name,
    required this.description,
    this.userId,
  });

  factory ListProduct.fromMap(Map<String, dynamic> json) => ListProduct(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    userId: json['user_id'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'user_id': userId,
  };
}
