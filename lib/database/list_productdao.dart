import 'package:projeto_dupla_aplicativos/database/database_helper.dart';
import 'package:projeto_dupla_aplicativos/modals/list_product.dart';
import 'package:sqflite/sqflite.dart';

class ListProductdao {
  ListProductdao();

  //read
  Future<List<ListProduct>> getListProduct({required int userId}) async {
    Database db = await DatabaseHelper.instance.database;
    var lists = await db.query(
      'lists_product',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    List<ListProduct> listProductList = lists.isNotEmpty
        ? lists.map((item) => ListProduct.fromMap(item)).toList()
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
