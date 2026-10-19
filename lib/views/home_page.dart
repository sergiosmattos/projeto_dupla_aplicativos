import 'package:flutter/material.dart';
import 'package:projeto_dupla_aplicativos/database/list_product_dao.dart';
import 'package:projeto_dupla_aplicativos/database/product_dao.dart';
import 'package:projeto_dupla_aplicativos/models/list_product.dart';
import 'package:projeto_dupla_aplicativos/models/user.dart';
import 'package:projeto_dupla_aplicativos/views/add_list_product.dart';
import 'package:projeto_dupla_aplicativos/views/list_product_item.dart';
import 'package:projeto_dupla_aplicativos/views/user_drawer.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductDao productdao = ProductDao();
  ListProductDao listProductDao = ListProductDao();

  void deleteListProduct(ListProduct listProduct) {
    setState(() {
      listProductDao.remove(listProduct);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tobuy',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: UserDrawer(user: widget.user),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddListProduct(userId: widget.user.id),
            ),
          );
          setState(() {});
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
      ),

      body: FutureBuilder(
        future: listProductDao.getListProduct(widget.user.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? const Center(child: Text("Nenhuma lista"))
                : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      ListProduct currentListProduct = snapshot.data![index];
                      return ListProductItem(
                        listProduct: currentListProduct,
                        deleteItem: () => deleteListProduct(currentListProduct),
                      );
                    },
                  );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
