import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeService {
  final _sathishBox = GetStorage();
  final _key = 'isDarkMode';
  _saveThemeToBox(bool isDarkMode) => _sathishBox.write(_key, isDarkMode);
  bool _loadThemeFromBox() => _sathishBox.read(_key) ?? false;
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
