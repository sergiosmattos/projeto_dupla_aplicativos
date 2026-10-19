import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projeto_dupla_aplicativos/database/session.dart';
import 'package:projeto_dupla_aplicativos/database/user_dao.dart';
import 'package:projeto_dupla_aplicativos/models/user.dart';
import 'package:projeto_dupla_aplicativos/views/form_fields/image_form_field.dart';
import 'package:projeto_dupla_aplicativos/views/home_page.dart';

class UserFormPage extends StatefulWidget {
  final User? _user;
  final bool _cadastro;
  const UserFormPage({super.key, User? user, bool cadastro = false})
    : _cadastro = cadastro,
      _user = user;

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  XFile? _currentImage;

  UserDao userDao = UserDao();

  @override
  void initState() {
    super.initState();
    if (widget._user != null) {
      _nomeController.text = widget._user!.name;
      _emailController.text = widget._user!.email;

      String? userProfileImage = widget._user!.profileImage;

      if (userProfileImage != null) {
        _currentImage = XFile(userProfileImage);
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget._user == null
              ? (widget._cadastro ? "Cadastro" : "Entrada")
              : "Alterando o usuário",
          style: TextStyle(color: colorScheme.primaryContainer),
        ),
        leading: widget._user == null
            ? null
            : IconButton(
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
                  if (widget._user != null || widget._cadastro)
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entre com o nome';
                        }
                        return null;
                      },
                    ),
                  TextFormField(
                    controller: _emailController,
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
                    controller: _senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: widget._user == null
                          ? 'Senha'
                          : 'Nova senha (deixe em branco para manter)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // só é obrigatória na entrada e no cadastro
                        return widget._user == null
                            ? 'Entre com a senha'
                            : null;
                      }
                      if ((widget._user != null || widget._cadastro) &&
                          value.length < 6) {
                        return 'A senha precisa ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  Visibility(
                    visible: (widget._user != null),
                    child: ImageFormfield(
                      fallback: Image.asset(
                        "assets/images/${User.defaultUnknownImage}",
                      ),
                      imageHolder: _currentImage,
                      validator: (value) => null,
                      onTap: (pickedImage) {
                        setState(() {
                          _currentImage = pickedImage;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String? savedPath;

                        if (_currentImage != null) {
                          Directory documentDir =
                              await getApplicationDocumentsDirectory();

                          savedPath = join(
                            documentDir.path,
                            _currentImage!.name,
                          );

                          _currentImage!.saveTo(savedPath);
                        }

                        if (widget._user == null) {
                          // entrada ou cadastro
                          User? user;

                          if (widget._cadastro) {
                            user = await userDao.create(
                              _nomeController.text,
                              _emailController.text,
                              _senhaController.text,
                              savedPath,
                            );
                          } else {
                            user = await userDao.login(
                              _emailController.text,
                              _senhaController.text,
                            );
                          }

                          if (!context.mounted) {
                            return;
                          }

                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  widget._cadastro
                                      ? "Esse e-mail já está cadastrado"
                                      : "E-mail ou senha incorretos",
                                ),
                              ),
                            );
                            return;
                          }

                          await Session.saveUserId(user.id!);

                          if (!context.mounted) {
                            return;
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(user: user!),
                            ),
                          );
                        } else {
                          // alterando o usuário
                          bool saved = await userDao.update(
                            widget._user!,
                            _nomeController.text,
                            _emailController.text,
                            _senhaController.text,
                            savedPath,
                          );

                          if (!context.mounted) {
                            return;
                          }

                          if (!saved) {
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
                      widget._user == null
                          ? (widget._cadastro ? "Cadastrar" : "Entrar")
                          : "Salvar",
                      style: TextStyle(color: colorScheme.primaryContainer),
                    ),
                  ),
                  if (widget._user == null)
                    TextButton(
                      onPressed: () {
                        // abre a mesma tela no outro modo
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserFormPage(cadastro: !widget._cadastro),
                          ),
                        );
                      },
                      child: Text(
                        widget._cadastro ? "Já tenho conta" : "Fazer cadastro",
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
