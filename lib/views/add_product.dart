import 'package:flutter/material.dart';
import 'package:projeto_dupla_aplicativos/database/product_dao.dart';
import 'package:projeto_dupla_aplicativos/models/product.dart';

class AddProduct extends StatefulWidget {
  final Product? product;
  final int? listId;

  const AddProduct({super.key, this.product, this.listId});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _validadeController = TextEditingController();
  DateTime _produtoValidade = DateTime.now();
  ProductDao productdao = ProductDao();
  
  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _amountController.text = widget.product!.amount.toString();
      _priceController.text = widget.product!.price.toString();
      _produtoValidade = widget.product!.validade;
    }
    _validadeController.text = _formatarData(_produtoValidade);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _priceController.dispose();
    _validadeController.dispose();
    super.dispose();
  }

  String _formatarData(DateTime data) =>
      '${data.day}/${data.month}/${data.year}';

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: widget.product == null
            ? Text(
                "Novo produto",
                style: TextStyle(color: colorScheme.primaryContainer),
              )
            : Text(
                'Alterando o produto',
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
                            WidgetSpan(child: Text('Nome')),
                          ],
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entre com o nome';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            WidgetSpan(child: Text('Quantidade')),
                          ],
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entre com a quantidade';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Quantidade precisa ser um número inteiro';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      label: Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            WidgetSpan(child: Text('Preço')),
                          ],
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entre com o preço';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Preço inválido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _validadeController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Validade'),
                    onTap: () async {
                      final DateTime? escolhida = await showDatePicker(
                        context: context,
                        initialDate: _produtoValidade,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2050),
                      );
                      if (escolhida != null) {
                        setState(() {
                          _produtoValidade = escolhida;
                          _validadeController.text = _formatarData(escolhida);
                        });
                      }
                    },
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final int amount = int.parse(_amountController.text);
                        final double price = double.parse(
                          _priceController.text,
                        );

                        if (widget.product == null) {
                          Product produto = Product(
                            id: widget.product?.id,
                            name: _nameController.text,
                            amount: amount,
                            price: price,
                            validade: _produtoValidade,
                            listsProductId: widget.listId,
                          );

                          int id = await productdao.add(produto);
                          produto.id = id;
                        } else {
                          widget.product!.name = _nameController.text;
                          widget.product!.amount = amount;
                          widget.product!.price = price;
                          widget.product!.validade = _produtoValidade;
                          await productdao.update(widget.product!);
                        }

                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Salvando Produto")),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "salvar",
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
