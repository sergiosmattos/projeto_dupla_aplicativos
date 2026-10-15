import 'package:flutter/material.dart';
import 'package:projeto_aula11_turma_b/database/productdao.dart';
import 'package:projeto_aula11_turma_b/modals/list_product.dart';
import 'package:projeto_aula11_turma_b/modals/product.dart';
import 'package:projeto_aula11_turma_b/views/add_product.dart';
import 'package:projeto_aula11_turma_b/views/product_item.dart';

class ProductsScreen extends StatefulWidget {
  final ListProduct listProduct;
  const ProductsScreen({super.key, required this.listProduct});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Productdao productdao = Productdao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.listProduct.name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<List<Product>>(
        future: productdao.filter(listId: widget.listProduct.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto nesta lista'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Product product = snapshot.data![index];
              return ProductItem(
                product: product,
                deleteItem: () async {
                  await productdao.remove(product);
                  setState(() {});
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProduct(listId: widget.listProduct.id),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
