class Product {
  int? id;
  String name;
  int amount;
  double price;
  bool buyed;
  DateTime validade;
  int? listProductId;

  Product({
    this.id,
    required this.name,
    required this.amount,
    required this.price,
    this.buyed = false,
    required this.validade,
    //required
    this.listProductId,
  });

  void buy() {
    buyed = !buyed;
  }

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    amount: json['amount'],
    price: json['price'],
    buyed: json['buyed'] == 0 ? false : true,
    validade: DateTime.parse(json['validade']),
    listProductId: json['list_product_id'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'amount': amount,
    'price': price,
    'buyed': buyed ? 1 : 0,
    'validade': validade.toIso8601String(),
    'list_product_id': listProductId,
  };
}
