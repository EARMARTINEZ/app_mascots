import 'package:flutter/material.dart';
import 'package:frontend/src/pages/form.dart';
import 'package:frontend/src/pages/list.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Home extends StatefulWidget {
  int state;
  int id;
  Home(this.state, this.id);
  @override
  _HomeState createState() => _HomeState(this.state, this.id);
}

class _HomeState extends State<Home> {
  int state;
  int id;
  int _currentIndex = 0;
  Widget _body;
  String _title;
  _HomeState(this.state, this.id);
  @override
  void initState() {
    super.initState();
    changeView(state);
  }

  void _onTap(index) {
    changeView(index);
  }

  void changeView(index) {
    _currentIndex = index;
    setState(() {
      switch (index) {
        case 0:
          {
            _title = "Mascots";
            _body = MyForm(this.id);
            break;
          }
        case 1:
          {
            _title = "List Mascots";
            _body = MyList();
            break;
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''), // English, no country code
          Locale('es', ''), // Spanish, no country code
        ],
        home: Scaffold(
          appBar: AppBar(title: Text(_title)),
          body: _body,
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.add), title: Text("Add")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.table_chart), title: Text("View")),
            ],
            currentIndex: _currentIndex,
            onTap: _onTap,
          ),
        ));
  }
}
