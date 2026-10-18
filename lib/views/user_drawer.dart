import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projeto_dupla_aplicativos/database/session.dart';
import 'package:projeto_dupla_aplicativos/database/user_dao.dart';
import 'package:projeto_dupla_aplicativos/models/user.dart';
import 'package:projeto_dupla_aplicativos/views/user_form_page.dart';

class UserDrawer extends StatelessWidget {
  final User user;
  UserDrawer({super.key, required this.user});

  final UserDao userDao = UserDao();

  // apaga a sessão salva e volta para a entrada, apagando TODAS as telas anteriores
  Future<void> _sair(NavigatorState navigator) async {
    await Session.clear();
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const UserFormPage()),
      (route) => false,
    );
  }

  Future<void> _deletarConta(BuildContext context) async {
    final navigator = Navigator.of(context);

    bool? confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar conta'),
        content: const Text(
          'Tem certeza que deseja deletar sua conta? '
          'Suas listas e produtos também serão apagados. '
          'Essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );

    if (confirmou != true) {
      return;
    }

    await userDao.remove(user);
    await _sair(navigator);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            accountName: Text(user.name),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              child: (user.profileImage == null)
                  ? Text(user.name[0].toUpperCase())
                  : Image.file(File(user.profileImage!)),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Editar usuário'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop(); // fecha o drawer
              navigator.push(
                MaterialPageRoute(
                  builder: (context) => UserFormPage(user: user),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Deletar conta'),
            onTap: () => _deletarConta(context),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Sair'),
            onTap: () => _sair(Navigator.of(context)),
          ),
        ],
      ),
    );
  }
}
