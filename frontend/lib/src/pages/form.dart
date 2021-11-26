import 'package:flutter/material.dart';
import 'user.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../app.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MyForm extends StatefulWidget {
  int id;
  MyForm(this.id);
  @override
  _MyFormState createState() => _MyFormState(this.id);
}

class _MyFormState extends State<MyForm> {
  int id;
  _MyFormState(this.id);
  Pets pets = Pets(0, '', '', '', '');
  TextEditingController _inputFieldDateController = new TextEditingController();
  Future save() async {
    if (pets.id == 0) {
      await http.post("http://192.168.88.17:1337/mascots/",
          headers: <String, String>{
            'Context-Type': 'application/json;charset=UTF-8'
          },
          body: <String, String>{
            'name': pets.name,
            'edad': pets.edad,
            'raza': pets.raza,
            'sexo': pets.sexo
          });
    } else {
      await http.put("http://192.168.88.17:1337/mascots/${pets.id.toString()}",
          headers: <String, String>{
            'Context-Type': 'application/json;charset=UTF-8'
          },
          body: <String, String>{
            'name': pets.name,
            'edad': pets.edad,
            'raza': pets.raza,
            'sexo': pets.sexo
          });
    }
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Home(1, 0)));
  }

  @override
  void initState() {
    _getRazaListList();
    _getSexoListList();
    super.initState();
    if (this.id != 0) {
      getOne();
    }
  }

  void getOne() async {
    var data = await http.get("http://192.168.88.17:1337/mascots/${this.id}");
    var u = json.decode(data.body);
    setState(() {
      pets = Pets(u['id'], u['name'], u['edad'], u['raza'], u['sexo']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          child: Padding(
        padding: EdgeInsets.all(19.0),
        child: Column(
          children: <Widget>[
            Visibility(
              visible: false,
              child: TextField(
                  controller: TextEditingController(text: pets.id.toString())),
            ),
            TextField(
              controller: TextEditingController(text: pets.name),
              onChanged: (val) {
                pets.name = val;
              },
              decoration:
                  InputDecoration(labelText: "Name", icon: Icon(Icons.person)),
            ),
            TextField(
              controller: TextEditingController(text: pets.edad),
              onChanged: (val) {
                pets.edad = val;
              },
              decoration:
                  InputDecoration(labelText: "Edad", icon: Icon(Icons.person)),
            ),
            Divider(),
            TextField(
              enableInteractiveSelection: false,
              controller: _inputFieldDateController,
              onChanged: (val) {
                pets.edad = val;
              },
              decoration: InputDecoration(
                hintText: "Fecha de Nacimiento",
                labelText: "Fecha de Nacimiento",
                icon: Icon(Icons.person),
                suffixIcon: Icon(Icons.perm_contact_calendar),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectDate(context);
              },
            ),

            //Sexo
            Divider(),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          value: _mySexo,
                          iconSize: 30,
                          icon: (null),
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                          hint: Text('Select Sexo'),
                          onChanged: (String newValue) {
                            setState(() {
                              _mySexo = newValue;
                              _getSexoListList();
                            });
                            pets.sexo = _mySexo;
                          },
                          items: sexoList?.map((item) {
                                //print(item);
                                return new DropdownMenuItem(
                                  child: new Text(item['value']),
                                  value: item['id'].toString(),
                                );
                              })?.toList() ??
                              [],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Raza Container
            Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          value: _myRaza,
                          iconSize: 30,
                          icon: (null),
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                          hint: Text('Select Raza'),
                          onChanged: (String newValue) {
                            setState(() {
                              _myRaza = newValue;
                              _getRazaListList();
                            });
                            pets.raza = newValue;
                          },
                          items: razaList?.map((item) {
                                //print(item);
                                return new DropdownMenuItem(
                                  child: new Text(item['value']),
                                  value: item['id'].toString(),
                                );
                              })?.toList() ??
                              [],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: MaterialButton(
                onPressed: save,
                minWidth: double.infinity,
                color: Colors.blue,
                textColor: Colors.white,
                child: Text("Save"),
              ),
            )
          ],
        ),
      )),
    );
  }

  List razaList;
  String _myRaza;

  String stateInfoUrl = 'http://192.168.88.17:1337/razas/';

  // ignore: missing_return
  Future<List<dynamic>> _getRazaListList() async {
    await http.get(stateInfoUrl).then((response) {
      var data = json.decode(response.body);

      var opciones = data;

      //print(opciones);

      setState(() {
        razaList = opciones;
      });
    });
  }

  List sexoList;
  String _mySexo;

  String saxoInfoUrl = 'http://192.168.88.17:1337/sexos/';

  // ignore: missing_return
  Future<List<dynamic>> _getSexoListList() async {
    await http.get(saxoInfoUrl).then((response) {
      var data = json.decode(response.body);

      var opciones = data;

      //print(opciones);

      setState(() {
        sexoList = opciones;
      });
    });
  }

  _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    String _fecha = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 1),
      locale: Locale('es', 'ES'),
    );
    if (picked != null) {
      setState(() {
        _fecha = DateFormat('yyyy-MM-dd').format(picked);
        String _fechaString = _fecha.toString();
        _inputFieldDateController.text = _fechaString;
      });
    }
  }
}
