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
    _listprodutoDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.listProduct == null
            ? Text(
                "Nova lista",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              )
            : Text(
                'Alterando a lista',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _listProductName,
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
                    controller: _listprodutoDescription,
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (widget.listProduct == null) {
                          ListProduct lista = ListProduct(
                            id: widget.listProduct?.id,
                            name: _listProductName.text,
                            description: _listprodutoDescription.text,
                          );

                          int id = await listProductdao.add(lista);
                          lista.id = id;
                        } else {
                          widget.listProduct!.name = _listProductName.text;
                          widget.listProduct!.description =
                              _listProductName.text;

                          await listProductdao.update(widget.listProduct!);
                        }

                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Salvando lista")),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "salvar lista",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
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
