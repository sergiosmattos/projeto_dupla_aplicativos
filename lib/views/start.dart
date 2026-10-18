import 'package:flutter/material.dart';
import 'package:projeto_dupla_aplicativos/database/session.dart';
import 'package:projeto_dupla_aplicativos/database/user_dao.dart';
import 'package:projeto_dupla_aplicativos/models/user.dart';
import 'package:projeto_dupla_aplicativos/views/home_page.dart';
import 'package:projeto_dupla_aplicativos/views/user_form_page.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  UserDao userDao = UserDao();

  @override
  void initState() {
    super.initState();
    _decidir();
  }

  Future<void> _decidir() async {
    User? user;
    int? id = await Session.getUserId();

    if (id != null) {
      user = await userDao.getById(id);

      if (user == null) {
        await Session.clear();
      }
    }

    if (!mounted) {
      return;
    }

    final User? usuariologado = user;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return usuariologado == null
              ? const UserFormPage()
              : HomePage(user: usuariologado);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
