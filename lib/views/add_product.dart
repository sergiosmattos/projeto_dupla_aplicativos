import 'package:flutter/material.dart';
import 'package:projeto_aula11_turma_b/database/productdao.dart';
import 'package:projeto_aula11_turma_b/modals/product.dart';

class AddProduct extends StatefulWidget {
  final Product? product;

  const AddProduct({super.key, this.product});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _produtoName = TextEditingController();
  final TextEditingController _produtoAmount = TextEditingController();
  final TextEditingController _produtoPrice = TextEditingController();
  final TextEditingController _produtoValidadeController =
      TextEditingController();
  DateTime _produtoValidade = DateTime.now();
  Productdao productdao = Productdao();
  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _produtoName.text = widget.product!.name;
      _produtoAmount.text = widget.product!.amount.toString();
      _produtoPrice.text = widget.product!.price.toString();
      _produtoValidade = widget.product!.validade;
    }
    _produtoValidadeController.text = _formatarData(_produtoValidade);
  }

  @override
  void dispose() {
    _produtoName.dispose();
    _produtoAmount.dispose();
    _produtoPrice.dispose();
    _produtoValidadeController.dispose();
    super.dispose();
  }

  String _formatarData(DateTime data) =>
      '${data.day}/${data.month}/${data.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.product == null
            ? Text(
                "Novo produto",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              )
            : Text(
                'Alterando o produto',
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
                    controller: _produtoName,
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
                    controller: _produtoAmount,
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
                    controller: _produtoPrice,
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
                    controller: _produtoValidadeController,
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
                          _produtoValidadeController.text = _formatarData(
                            escolhida,
                          );
                        });
                      }
                    },
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final int amount = int.parse(_produtoAmount.text);
                        final double price = double.parse(_produtoPrice.text);

                        if (widget.product == null) {
                          Product produto = Product(
                            id: widget.product?.id,
                            name: _produtoName.text,
                            amount: amount,
                            price: price,
                            validade: _produtoValidade,
                          );

                          int id = await productdao.add(produto);
                          produto.id = id;
                        } else {
                          widget.product!.name = _produtoName.text;
                          widget.product!.amount = amount;
                          widget.product!.price = price;
                          widget.product!.validade = _produtoValidade;
                          await productdao.update(widget.product!);
                        }

                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Salvando produto")),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "salvar",
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
