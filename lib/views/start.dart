import 'package:flutter/material.dart';
import 'package:projeto_dupla_aplicativos/database/session.dart';
import 'package:projeto_dupla_aplicativos/database/userdao.dart';
import 'package:projeto_dupla_aplicativos/modals/user.dart';
import 'package:projeto_dupla_aplicativos/views/auth.dart';
import 'package:projeto_dupla_aplicativos/views/home_page.dart';

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
        await Session.clear(); // a conta não existe mais
      }
    }

    if (!mounted) {
      return;
    }

    final User? logado = user;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            logado == null ? const Auth() : HomePage(user: logado),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
