import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/password_model.dart';

class PasswordProvider with ChangeNotifier {

  List<PasswordModel> _passwords = [];
  bool _isLoading = false;

  List<PasswordModel> get passwords => _passwords;
  bool get isLoading => _isLoading;

  // LOAD PASSWORDS
  Future<void> loadPasswords() async {
    _isLoading = true;
    notifyListeners();

    final data = await DBHelper.getPasswords();

    _passwords = data.map((e) => PasswordModel.fromMap(e)).toList();

    _isLoading = false;
    notifyListeners();
  }

  // ADD PASSWORD
  Future<void> addPassword(PasswordModel model) async {
    await DBHelper.insertPassword(model.toMap());
    await loadPasswords();
  }

  // UPDATE PASSWORD
  Future<void> updatePassword(PasswordModel model) async {
    if (model.id == null) return;

    await DBHelper.updatePassword(model.id!, model.toMap());
    await loadPasswords();
  }

  // DELETE PASSWORD
  Future<void> deletePassword(int id) async {
    await DBHelper.deletePassword(id);
    await loadPasswords();
  }

  // CLEAR DATA (optional)
  void clear() {
    _passwords = [];
    notifyListeners();
  }
}