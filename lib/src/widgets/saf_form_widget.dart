import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhsaf/src/models/models.dart';
import 'package:uhsaf/src/utils/utils.dart';
import 'package:uhsaf/src/widgets/widgets.dart';

class SAFFormWidget extends StatefulWidget {
  final SAFOnSave onSave;
  final SAFModel model;

  SAFFormWidget({Key key, @required this.onSave, this.model})
      : assert(model == null || model.id != null),
        super(key: key);

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
  void initState() {
    super.initState();
    controllers = [
      nameController,
      addressController,
      identifierController,
      opinionsController,
      causesController
    ];
    if (widget.model != null) {
      safController.text = widget.model.saf;
      nameController.text = widget.model.name;
      addressController.text = widget.model.address;
      identifierController.text = widget.model.identifier;
      opinionsController.text = widget.model.opinions;
      causesController.text = widget.model.causes;
      municipality = _prepareDropdownValue(widget.model.municipality);
      assistance = _prepareDropdownValue(widget.model.assistance);
      satisfaction = _prepareDropdownValue(widget.model.satisfaction);
      quality = _prepareDropdownValue(widget.model.quality);
    } else {
      SharedPreferences.getInstance().then((prefs) {
        final municipality = prefs.containsKey('municipality')
            ? prefs.getString('municipality')
            : null;
        final saf = prefs.containsKey('saf') ? prefs.getString('saf') : null;
        setState(() {
          this.municipality = municipality;
          safController.text = saf;
        });
      });
    }
  }

  String _prepareDropdownValue(String value) {
    return value != null && value.isEmpty ? null : value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Form(
        key: keyForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Municipality
            SAFDropdownField(
              value: municipality,
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
                  return 'El municipio es obligatorio';
                }
                return null;
              },
            ),
            // SAF
            SAFTextField(
              label: 'SAF',
              controller: safController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El SAF es obligatorio';
                }
                return null;
              },
            ),
            // Name
            SAFTextField(
              label: 'Nombre y Apellidos',
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre y los apellidos son obligatorios';
                }
                return null;
              },
            ),
            // Address
            SAFTextField(
              label: 'Dirección particular',
              controller: addressController,
              minLines: 1,
              maxLines: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La dirección particular es obligatoria';
                }
                return null;
              },
            ),
            // Identifier
            SAFTextField(
              label: 'No. de Carné de Identidad',
              controller: identifierController,
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
                signed: false,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El No. de Carné de Identidad es obligatorio';
                }
                if (value.length != 11 ||
                    value.characters.any((e) => !'0123456789'.contains(e))) {
                  return 'El No. de Carné de Identidad debe contener 11 dígitos';
                }
                return null;
              },
            ),
            // Assistance
            SAFDropdownField(
              value: assistance,
              label: 'Asiste al SAF',
              options: [
                'Diariamente',
                'Regularmente',
                'Ocasionalmente',
                'No asiste',
              ],
              onChanged: (value) {
                setState(() {
                  assistance = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Si asiste al SAF es obligatorio';
                }
                return null;
              },
            ),
            // Satisfaction
            SAFDropdownField(
              value: satisfaction,
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
                if (assistance != 'No asiste' && value == null) {
                  return 'El nivel de satisfacción es obligatorio';
                }
                return null;
              },
            ),
            // Quality
            SAFDropdownField(
              value: quality,
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
                if (assistance != 'No asiste' && value == null) {
                  return 'La calidad del servicio es obligatoria';
                }
                return null;
              },
            ),
            // Opinions
            SAFTextField(
              label: 'Opiniones generales sobre el servicio SAF',
              controller: opinionsController,
              minLines: 1,
              maxLines: 10,
            ),
            // Causes
            if (assistance == 'No asiste')
              SAFTextField(
                label: 'En caso de no asistir, ¿cuáles son las causas?',
                controller: causesController,
                minLines: 1,
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Si no asiste las causas son obligatorias';
                  }
                  return null;
                },
              ),
            // Save
            Container(
              margin: EdgeInsets.only(
                top: 10,
                bottom: MediaQuery.of(context).size.height / 2,
              ),
              child: Row(
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
                              municipality: municipality ?? '',
                              saf: safController.text?.trim() ?? '',
                              name: nameController.text?.trim() ?? '',
                              address: addressController.text?.trim() ?? '',
                              identifier:
                                  identifierController.text?.trim() ?? '',
                              assistance: assistance ?? '',
                              satisfaction: satisfaction ?? '',
                              quality: quality ?? '',
                              opinions: opinionsController.text?.trim() ?? '',
                              causes: causesController.text?.trim() ?? '',
                              id: widget.model?.id,
                            ),
                          );
                          if (isOk) {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('municipality', municipality);
                            await prefs.setString('saf', safController.text);
                            for (var controller in controllers) {
                              controller.clear();
                            }
                            setState(() {
                              assistance = null;
                              satisfaction = null;
                              quality = null;
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
