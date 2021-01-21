import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uhsaf/src/models/saf_model.dart';
import 'package:uhsaf/src/utils/utils.dart';
import 'package:uhsaf/src/widgets/widgets.dart';

class FormPage extends StatelessWidget {
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Formulario SAF'),
            centerTitle: true,
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
}
