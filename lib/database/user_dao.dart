import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:projeto_dupla_aplicativos/database/database_helper.dart';
import 'package:projeto_dupla_aplicativos/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  UserDao();

  String _hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  String _formatEmail(String email) => email.trim().toLowerCase();

  // create: devolve o usuário criado, ou null se o e-mail já existe
  Future<User?> create(
    String name,
    String email,
    String password,
    String? profileImage,
  ) async {
    Database db = await DatabaseHelper.instance.database;
    String formatedEmail = _formatEmail(email);

    var existe = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [formatedEmail],
    );

    if (existe.isNotEmpty) {
      return null;
    }

    User user = User(
      name: name.trim(),
      email: formatedEmail,
      passwordHash: _hash(password),
      profileImage: profileImage,
    );
    user.id = await db.insert('users', user.toMap());

    return user;
  }

  // login: devolve o usuário se e-mail e hash batem, senão null
  Future<User?> login(String email, String password) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.query(
      'users',
      where: 'email = ? AND password_hash = ?',
      whereArgs: [_formatEmail(email), _hash(password)],
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
    String newPassword,
    String? profileImage,
  ) async {
    Database db = await DatabaseHelper.instance.database;
    String formatedEmail = _formatEmail(email);

    var exists = await db.query(
      'users',
      where: 'email = ? AND id != ?',
      whereArgs: [formatedEmail, user.id],
    );

    if (exists.isNotEmpty) {
      return false;
    }

    user.name = name.trim();

    user.email = formatedEmail;

    user.profileImage = profileImage;

    if (newPassword.isNotEmpty) {
      user.passwordHash = _hash(newPassword);
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
