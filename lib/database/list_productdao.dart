import 'package:projeto_aula11_turma_b/database/database_helper.dart';
import 'package:projeto_aula11_turma_b/modals/list_product.dart';
import 'package:sqflite/sqflite.dart';

class ListProductdao {
  ListProductdao();

  //read
  Future<List<ListProduct>> getListProduct() async {
    Database db = await DatabaseHelper.instance.database;
    var listproducts = await db.query('lists_product', orderBy: 'id DESC');
    List<ListProduct> listProductList = listproducts.isNotEmpty
        ? listproducts.map((item) => ListProduct.fromMap(item)).toList()
        : [];
    return listProductList;
  }

  // create
  Future<int> add(ListProduct newListProduct) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert('lists_product', newListProduct.toMap());
  }

  // delete
  Future<int> remove(ListProduct listProduct) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.delete(
      'lists_product',
      where: 'id=?',
      whereArgs: [listProduct.id],
    );
  }

  // update
  Future<int> update(ListProduct listProduct) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.update(
      'lists_product',
      listProduct.toMap(),
      where: 'id=?',
      whereArgs: [listProduct.id],
    );
  }
}
