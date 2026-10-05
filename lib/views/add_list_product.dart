import 'package:flutter/material.dart';
import 'package:projeto_aula11_turma_b/database/list_productdao.dart';
import 'package:projeto_aula11_turma_b/modals/list_product.dart';

class AddListProduct extends StatefulWidget {
  final ListProduct? listProduct;
  const AddListProduct({super.key, this.listProduct});

  @override
  State<AddListProduct> createState() => _AddListProductState();
}

class _AddListProductState extends State<AddListProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _listProductName = TextEditingController();
  final TextEditingController _listprodutoDescription = TextEditingController();
  ListProductdao listProductdao = ListProductdao();

  @override
  void initState() {
    super.initState();
    if (widget.listProduct != null) {
      _listProductName.text = widget.listProduct!.name;
      _listprodutoDescription.text = widget.listProduct!.description;
    }
  }

  @override
  void dispose() {
    _listProductName.dispose();
    _listprodutoDescription.dispose(); //parei aqui
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
