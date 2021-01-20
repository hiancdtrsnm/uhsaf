import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uhsaf/src/pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme(
          id: 'light',
          data: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color.fromARGB(255, 181, 0, 0),
            accentColor: Color.fromARGB(255, 181, 0, 0),
            fontFamily: 'DINPro',
          ),
          description: 'Light theme',
        ),
        AppTheme(
          id: 'dark',
          data: ThemeData(
            brightness: Brightness.dark,
            accentColor: Color.fromARGB(255, 181, 0, 0),
            fontFamily: 'DINPro',
          ),
          description: 'Dark theme',
        ),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (context) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Formulario SAF',
            home: HomePage(),
          ),
        ),
      ),
    );
  }
}
