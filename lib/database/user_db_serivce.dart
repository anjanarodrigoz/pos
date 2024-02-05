import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/utils/val.dart';
import '../models/user.dart';

class UserDB {
  final _storage = GetStorage(DBVal.user);
  static final UserDB _instance = UserDB._internal();

  factory UserDB() {
    return _instance;
  }

  UserDB._internal();

  User getUser(String userName) {
    User user = User.fromJson(_storage.read(userName));
    return user;
  }

  Future<void> addUser(User user) async {
    await _storage.write(user.username, user.toJson());
  }

  Future<void> updateUser(User updatedUser) async {
    await _storage.write(updatedUser.username, updatedUser.toJson());
  }
}
