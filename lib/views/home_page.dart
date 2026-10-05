import 'package:flutter/material.dart';
import 'package:projeto_aula11_turma_b/database/list_productdao.dart';
import 'package:projeto_aula11_turma_b/database/productdao.dart';
import 'package:projeto_aula11_turma_b/modals/list_product.dart';
import 'package:projeto_aula11_turma_b/views/add_list_product.dart';
import 'package:projeto_aula11_turma_b/views/list_product_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Productdao productdao = Productdao();
  ListProductdao listProductdao = ListProductdao();

  void deleteListProduct(ListProduct listProduct) {
    setState(() {
      listProductdao.remove(listProduct);
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
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddListProduct()),
          );
          setState(() {});
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
      ),

      body: FutureBuilder(
        future: listProductdao.getListProduct(),
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
