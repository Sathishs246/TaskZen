import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:sqflite_todo_app/services/theme_services.dart';
import 'package:sqflite_todo_app/ui/home_page.dart';
import 'package:sqflite_todo_app/ui/splash_screen.dart';
import 'package:sqflite_todo_app/ui/theme.dart';

import 'db/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/home', page: () => HomePage()), // Your existing home
      ],
    );
  }
}
