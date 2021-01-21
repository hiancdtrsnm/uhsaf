import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uhsaf/src/models/models.dart';
import 'package:uhsaf/src/pages/pages.dart';
import 'package:uhsaf/src/utils/utils.dart';

class RegistersPage extends StatefulWidget {
  @override
  _RegistersPageState createState() => _RegistersPageState();
}

class _RegistersPageState extends State<RegistersPage> {
  final dbHelper = DatabaseHelper.instance;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Registros'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {});
                },
              ),
            ],
          ),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: dbHelper.queryAllRows(),
            builder: (context, snapshot) {
              // Failure
              if (snapshot.hasError) {
                log(snapshot.error.toString());
                return Center(
                  child: Text(
                    'Ha ocurrido un error inesperado, póngase en '
                    'contacto con el soporte técnico.',
                  ),
                );
              }
              // Loading
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              // Success
              try {
                final fromJson = SAFModel.fromJson;
                final results = snapshot.data
                    .map((x) => fromJson(x)..id = x[DatabaseHelper.columnId])
                    .where((x) =>
                        x.name.contains(controller.text) ||
                        x.address.contains(controller.text) ||
                        x.municipality.contains(controller.text) ||
                        x.saf.contains(controller.text))
                    .toList();
                return ListView.builder(
                  itemCount: results.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        margin: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          top: 15,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Buscar',
                            hintText: 'Buscar',
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          controller: controller,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      );
                    }
                    final item = results[index - 1];
                    return GestureDetector(
                      onTap: () async {
                        await Get.to(FormPage(model: item));
                        setState(() {});
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 20,
                            right: 15,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Id: ${item.id}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Nombre: ${item.name}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Dirección: ${item.address}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Municipio: ${item.municipality}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'SAF: ${item.saf}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } catch (e) {
                log(e.toString());
                return Center(
                  child: Text(
                    'Ha ocurrido un error inesperado, póngase en '
                    'contacto con el soporte técnico.',
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
