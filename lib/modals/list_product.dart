class ListProduct {
  int? id;
  String name;
  String description;

  ListProduct({this.id, required this.name, required this.description});

  factory ListProduct.fromMap(Map<String, dynamic> json) => ListProduct(
    id: json['id'],
    name: json['name'],
    description: json['description'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
  };
}
