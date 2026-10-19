import 'package:flutter/material.dart';
import 'package:projeto_dupla_aplicativos/database/list_product_dao.dart';
import 'package:projeto_dupla_aplicativos/models/list_product.dart';

class AddListProduct extends StatefulWidget {
  final ListProduct? listProduct;
  final int? userId;
  const AddListProduct({super.key, this.listProduct, this.userId});

  @override
  State<AddListProduct> createState() => _AddListProductState();
}

class _AddListProductState extends State<AddListProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  ListProductDao listProductdao = ListProductDao();

  @override
  void initState() {
    super.initState();
    if (widget.listProduct != null) {
      _nameController.text = widget.listProduct!.name;
      _descriptionController.text = widget.listProduct!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: widget.listProduct == null
            ? Text(
                "Nova lista",
                style: TextStyle(color: colorScheme.primaryContainer),
              )
            : Text(
                'Alterando a lista',
                style: TextStyle(color: colorScheme.primaryContainer),
              ),
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.primaryContainer),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: colorScheme.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: size.height * 0.0125,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      label: Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            WidgetSpan(child: Text('Nome da lista')),
                          ],
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entre com o nome da lista';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      label: Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            WidgetSpan(child: Text('Descrição da lista')),
                          ],
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entre com a descrição da lista';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (widget.listProduct == null) {
                          ListProduct lista = ListProduct(
                            id: widget.listProduct?.id,
                            name: _nameController.text,
                            description: _descriptionController.text,
                            userId: widget.userId,
                          );

                          int id = await listProductdao.add(lista);
                          lista.id = id;
                        } else {
                          widget.listProduct!.name = _nameController.text;
                          widget.listProduct!.description =
                              _descriptionController.text;

                          await listProductdao.update(widget.listProduct!);
                        }

                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Salvando Lista")),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Salvar Lista",
                      style: TextStyle(color: colorScheme.primaryContainer),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
