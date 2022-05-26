import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final _key = 'isDarkMode';

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  bool loadThemeFromBox() => _box.read<bool>(_key) ?? false;

  ThemeMode get theme => loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchMode() {
    Get.changeThemeMode(loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!loadThemeFromBox());
  }
}
