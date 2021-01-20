import 'package:flutter/material.dart';
import 'package:uhsaf/src/models/models.dart';
import 'package:uhsaf/src/utils/utils.dart';
import 'package:uhsaf/src/widgets/widgets.dart';

class SAFFormWidget extends StatefulWidget {
  final SAFOnSave onSave;

  const SAFFormWidget({Key key, @required this.onSave}) : super(key: key);

  @override
  _SAFFormWidgetState createState() => _SAFFormWidgetState();
}

class _SAFFormWidgetState extends State<SAFFormWidget> {
  final keyForm = GlobalKey<FormState>();
  final safController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final identifierController = TextEditingController();
  final opinionsController = TextEditingController();
  final causesController = TextEditingController();
  String municipality;
  String assistance;
  String satisfaction;
  String quality;
  List<TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
    if (controllers == null) {
      controllers = [
        safController,
        nameController,
        addressController,
        identifierController,
        opinionsController,
        causesController
      ];
    }
    return Container(
      margin: EdgeInsets.all(10),
      child: Form(
        key: keyForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            SAFDropdownField(
              label: 'Municipio',
              options: [
                'Arroyo Naranjo',
                'Boyeros',
                'Centro Habana',
                'Cerro',
                'Cotorro',
                'Diez de Octubre',
                'Guanabacoa',
                'Habana del Este',
                'La Habana Vieja',
                'La Lisa',
                'Marianao',
                'Playa',
                'Plaza',
                'Regla',
                'San Miguel del Padrón',
              ],
              onChanged: (value) {
                setState(() {
                  municipality = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Campo obligatorio';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            SAFTextField(
              label: 'SAF',
              controller: safController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obligatorio';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            SAFTextField(
              label: 'Nombre y Apellidos',
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obligatorio';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            SAFTextField(
              label: 'Dirección particular',
              controller: addressController,
              minLines: 1,
              maxLines: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obligatorio';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            SAFTextField(
              label: 'No. de Carné de Identidad',
              controller: identifierController,
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
                signed: false,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obligatorio';
                }
                if (value.length != 11 ||
                    value.characters.any((e) => !'0123456789'.contains(e))) {
                  return 'Deben ser 11 dígitos';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            SAFDropdownField(
              label: 'Asiste al SAF',
              options: [
                'Diariamente',
                'Regularmente',
                'Ocasionalmente',
                'No asite',
              ],
              onChanged: (value) {
                setState(() {
                  assistance = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Campo obligatorio';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            SAFDropdownField(
              label: 'Nivel de satisfacción',
              options: [
                'Alto',
                'Medio',
                'Bajo',
              ],
              onChanged: (value) {
                setState(() {
                  satisfaction = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Campo obligatorio';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            SAFDropdownField(
              label: 'Calidad del servicio',
              options: [
                'Bueno',
                'Regular',
                'Malo',
              ],
              onChanged: (value) {
                setState(() {
                  quality = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Campo obligatorio';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            SAFTextField(
              label: 'Opiniones generales sobre el servicio SAF',
              controller: opinionsController,
              minLines: 1,
              maxLines: 10,
            ),
            SizedBox(height: 10),
            SAFTextField(
              label: 'En caso de no asistir, ¿cuáles son las causas?',
              controller: causesController,
              minLines: 1,
              maxLines: 10,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      child: Text('Guardar'),
                    ),
                    onPressed: () async {
                      if (keyForm.currentState.validate()) {
                        final isOk = await widget.onSave(
                          SAFModel(
                            municipality: municipality,
                            saf: safController.text.trim(),
                            name: nameController.text.trim(),
                            address: addressController.text.trim(),
                            identifier: identifierController.text.trim(),
                            assistance: assistance,
                            satisfaction: satisfaction,
                            quality: quality,
                            opinions: opinionsController.text.trim(),
                            causes: causesController.text.trim(),
                          ),
                        );
                        if(isOk) {
                          keyForm.currentState.reset();
                          for (var controller in controllers) {
                            controller.clear();
                            print(controller);
                          }
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 2),
          ],
        ),
      ),
    );
  }
}
