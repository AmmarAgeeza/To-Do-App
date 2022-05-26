import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/theme.dart';

import 'db/db_helper.dart';

import 'ui/pages/home_page.dart';

//import 'ui/pages/home_page.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  DBHelper.initDb();
  GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
