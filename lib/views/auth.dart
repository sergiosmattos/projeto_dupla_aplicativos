import 'package:flutter/material.dart';
import 'package:projeto_dupla_aplicativos/database/session.dart';
import 'package:projeto_dupla_aplicativos/database/userdao.dart';
import 'package:projeto_dupla_aplicativos/modals/user.dart';
import 'package:projeto_dupla_aplicativos/views/home_page.dart';

class Auth extends StatefulWidget {
  final User? user;
  final bool cadastro;
  const Auth({super.key, this.user, this.cadastro = false});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  UserDao userDao = UserDao();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nome.text = widget.user!.name;
      _email.text = widget.user!.email;
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user == null
              ? (widget.cadastro ? "Cadastro" : "Entrada")
              : "Alterando o usuário",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        leading: widget.user == null
            ? null
            : IconButton(
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
                  if (widget.user != null || widget.cadastro)
                    TextFormField(
                      controller: _nome,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entre com o nome';
                        }
                        return null;
                      },
                    ),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _senha,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: widget.user == null
                          ? 'Senha'
                          : 'Nova senha (deixe em branco para manter)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // só é obrigatória na entrada e no cadastro
                        return widget.user == null ? 'Entre com a senha' : null;
                      }
                      if ((widget.user != null || widget.cadastro) &&
                          value.length < 6) {
                        return 'A senha precisa ter pelo menos 6 caracteres';
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
                        if (widget.user == null) {
                          // entrada ou cadastro
                          User? user;
                          if (widget.cadastro) {
                            user = await userDao.create(
                              _nome.text,
                              _email.text,
                              _senha.text,
                            );
                          } else {
                            user = await userDao.login(
                              _email.text,
                              _senha.text,
                            );
                          }

                          if (!context.mounted) {
                            return;
                          }

                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  widget.cadastro
                                      ? "Esse e-mail já está cadastrado"
                                      : "E-mail ou senha incorretos",
                                ),
                              ),
                            );
                            return;
                          }

                          final User logado = user;
                          await Session.save(logado.id!);

                          if (!context.mounted) {
                            return;
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(user: logado),
                            ),
                          );
                        } else {
                          // alterando o usuário
                          bool salvou = await userDao.update(
                            widget.user!,
                            _nome.text,
                            _email.text,
                            _senha.text,
                          );

                          if (!context.mounted) {
                            return;
                          }

                          if (!salvou) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Esse e-mail já está em uso"),
                              ),
                            );
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Salvando usuário")),
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Text(
                      widget.user == null
                          ? (widget.cadastro ? "cadastrar" : "entrar")
                          : "salvar",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                  if (widget.user == null)
                    TextButton(
                      onPressed: () {
                        // abre a mesma tela no outro modo
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Auth(cadastro: !widget.cadastro),
                          ),
                        );
                      },
                      child: Text(
                        widget.cadastro ? "Já tenho conta" : "Fazer cadastro",
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
