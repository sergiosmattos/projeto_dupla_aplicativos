import 'package:flutter/material.dart';
import 'package:projeto_aula11_turma_b/modals/list_product.dart';
import 'package:projeto_aula11_turma_b/views/add_list_product.dart';
import 'package:projeto_aula11_turma_b/views/add_product.dart';

class ListProductItem extends StatefulWidget {
  final ListProduct listProduct;
  final Function() deleteItem;
  const ListProductItem({
    super.key,
    required this.listProduct,
    required this.deleteItem,
  });

  @override
  State<ListProductItem> createState() => _ListProductItemState();
}

class _ListProductItemState extends State<ListProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(8),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(widget.listProduct.name),
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        subtitle: Text(widget.listProduct.description),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProduct()),
          );
          setState(() {});
        },
        trailing: Wrap(
          children: [
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddListProduct(listProduct: widget.listProduct),
                  ),
                );
                setState(() {});
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: widget.deleteItem,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
