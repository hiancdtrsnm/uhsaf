import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uhsaf/src/models/models.dart';
import 'package:uhsaf/src/utils/utils.dart';
import 'package:uhsaf/src/widgets/widgets.dart';

class FormPage extends StatelessWidget {
  final SAFModel model;
  final dbHelper = DatabaseHelper.instance;

  FormPage({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(model == null ? 'Insertar' : 'Editar'),
            centerTitle: true,
            actions: [
              if (model != null)
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Get.dialog(ThemeConsumer(
                      child: AlertDialog(
                        title: Text('Confirme'),
                        content: Text(
                          '¿Está usted seguro de que desea eliminar el'
                          'registro?',
                        ),
                        actions: [
                          FlatButton(
                            onPressed: () async {
                              Get.back();
                              try {
                                await dbHelper.delete(model.id);
                                Get.back();
                                Get.rawSnackbar(
                                  message:
                                      'Se eliminó el registro correctamente',
                                );
                              } catch (e) {
                                log(e.toString());
                                Get.rawSnackbar(
                                  message: 'Hubo un error al eliminar el '
                                      'registro',
                                );
                              }
                            },
                            child: Text(
                              'Si',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Colors.white
                                        : ThemeProvider.themeOf(context)
                                            .data
                                            .primaryColor,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Colors.white
                                        : ThemeProvider.themeOf(context)
                                            .data
                                            .primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
                  },
                )
            ],
          ),
          body: SingleChildScrollView(
            child: SAFFormWidget(onSave: _onSave, model: model),
          ),
        ),
      ),
    );
  }

  Future<bool> _onSave(SAFModel model) async {
    try {
      if (model.id == null) {
        await dbHelper.insert(model.toJson());
      } else {
        final columnId = DatabaseHelper.columnId;
        await dbHelper.update(model.toJson()..addAll({columnId: model.id}));
        Get.back();
      }
      Get.rawSnackbar(message: 'Datos guardados correctamente');
      return true;
    } catch (e) {
      log(e.toString());
      Get.rawSnackbar(message: 'Hubo un error al guardar los datos');
      return false;
    }
  }
}
