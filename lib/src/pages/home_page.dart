import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:share/share.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uhsaf/src/models/saf_model.dart';
import 'package:uhsaf/src/utils/utils.dart';
import 'package:uhsaf/src/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Formulario SAF'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.share),
                onPressed: _share,
              )
            ],
          ),
          drawer: Drawer(
            child: Container(
              color: ThemeProvider.themeOf(context).data.primaryColor,
              child: Stack(
                children: [
                  Align(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 100),
                            child: Image.asset('assets/images/matcom.png'),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Desarrollado por la Facultad de Matemática y '
                            'Computación de la Universidad de La Habana',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    alignment: AlignmentDirectional.bottomCenter,
                  ),
                  ListView(
                    children: [
                      DrawerHeader(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Image.asset('assets/images/logo.png'),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Exportar Datos',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Get.back();
                          _share();
                        },
                      ),
                    ],
                  ),
                  Align(
                    child: Container(
                      margin: EdgeInsets.only(top: 0),
                      child: IconButton(
                        icon: Icon(
                          ThemeProvider.themeOf(context).id == 'dark'
                              ? Icons.wb_sunny_outlined
                              : Icons.wb_sunny,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          ThemeProvider.controllerOf(context).nextTheme();
                        },
                      ),
                    ),
                    alignment: AlignmentDirectional.topEnd,
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: SAFFormWidget(onSave: _onSave),
          ),
        ),
      ),
    );
  }

  Future<bool> _onSave(SAFModel model) async {
    try {
      await dbHelper.insert(model.toJson());
      Get.rawSnackbar(message: 'Datos guardados correctamente');
      return true;
    } catch (e) {
      log(e.toString());
      Get.rawSnackbar(message: 'Hubo un error al guardar los datos');
      return false;
    }
  }

  Future<void> _share() async {
    String csvPath = await dbHelper.saveCSV();
    Share.shareFiles(['$csvPath'], text: 'Database CSV');
  }
}
