import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:projeto_dupla_aplicativos/database/database_helper.dart';
import 'package:projeto_dupla_aplicativos/modals/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  UserDao();

  String _hash(String senha) => sha256.convert(utf8.encode(senha)).toString();

  String _limpaEmail(String email) => email.trim().toLowerCase();

  // create: devolve o usuário criado, ou null se o e-mail já existe
  Future<User?> create(String name, String email, String senha) async {
    Database db = await DatabaseHelper.instance.database;
    String emailLimpo = _limpaEmail(email);
    var existe = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [emailLimpo],
    );
    if (existe.isNotEmpty) {
      return null;
    }
    User user = User(
      name: name.trim(),
      email: emailLimpo,
      passwordHash: _hash(senha),
    );
    user.id = await db.insert('users', user.toMap());
    return user;
  }

  // login: devolve o usuário se e-mail e hash batem, senão null
  Future<User?> login(String email, String senha) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.query(
      'users',
      where: 'email = ? AND password_hash = ?',
      whereArgs: [_limpaEmail(email), _hash(senha)],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  // read: usado pela sessão salva para recuperar o usuário pelo id
  Future<User?> getById(int id) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  // update: devolve false se o e-mail já pertence a outro usuário.
  // novaSenha vazia = mantém a senha atual
  Future<bool> update(
    User user,
    String name,
    String email,
    String novaSenha,
  ) async {
    Database db = await DatabaseHelper.instance.database;
    String emailLimpo = _limpaEmail(email);
    var existe = await db.query(
      'users',
      where: 'email = ? AND id != ?',
      whereArgs: [emailLimpo, user.id],
    );
    if (existe.isNotEmpty) {
      return false;
    }
    user.name = name.trim();
    user.email = emailLimpo;
    if (novaSenha.isNotEmpty) {
      user.passwordHash = _hash(novaSenha);
    }
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return true;
  }

  // delete: o ON DELETE CASCADE apaga também as listas e os produtos do usuário
  Future<int> remove(User user) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [user.id]);
  }
}
