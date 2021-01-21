import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:share/share.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uhsaf/src/pages/pages.dart';
import 'package:uhsaf/src/utils/utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {});
                },
              ),
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
                          Icons.input,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Formulario',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          Get.back();
                          await Get.to(FormPage());
                          setState(() {});
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.list_alt,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Registros',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          Get.back();
                          await Get.to(RegistersPage());
                          setState(() {});
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Exportar',
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/ilustration.png'),
              buildButton(
                context: context,
                text: 'Formulario',
                onPressed: () async {
                  await Get.to(FormPage());
                  setState(() {});
                },
              ),
              buildButton(
                context: context,
                text: 'Registros',
                onPressed: () async {
                  await Get.to(RegistersPage());
                  setState(() {});
                },
              ),
              buildButton(
                context: context,
                text: 'Exportar',
                onPressed: _share,
              ),
              FutureBuilder<int>(
                future: dbHelper.queryRowCount(),
                builder: (context, snapshot) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      snapshot.hasData
                          ? 'Cantidad de registros: ${snapshot.data}'
                          : '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _share() async {
    String csvPath = await dbHelper.saveCSV();
    Share.shareFiles(['$csvPath'], text: 'Database CSV');
  }

  Widget buildButton({
    @required BuildContext context,
    @required String text,
    @required VoidCallback onPressed,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                child: Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeProvider.themeOf(context).id == 'dark'
                        ? Colors.white
                        : ThemeProvider.themeOf(context).data.primaryColor,
                  ),
                ),
              ),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
