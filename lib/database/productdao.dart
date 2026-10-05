import 'package:projeto_aula11_turma_b/database/database_helper.dart';
import 'package:projeto_aula11_turma_b/modals/product.dart';
import 'package:sqflite/sqflite.dart';

class Productdao {
  Productdao();

  // read
  Future<List<Product>> getProduct() async {
    Database db = await DatabaseHelper.instance.database;
    var products = await db.query('products', orderBy: 'id DESC');
    List<Product> productList = products.isNotEmpty
        ? products.map((item) => Product.fromMap(item)).toList()
        : [];
    return productList;
  }

  // create
  Future<int> add(Product newProduct) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert('products', newProduct.toMap());
  }

  // delete
  Future<int> remove(Product product) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.delete('products', where: 'id=?', whereArgs: [product.id]);
  }

  // update
  Future<int> update(Product product) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id=?',
      whereArgs: [product.id],
    );
  }
}
