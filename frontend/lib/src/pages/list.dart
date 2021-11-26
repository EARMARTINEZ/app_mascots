import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'user.dart';
import 'detail.dart';

class MyList extends StatefulWidget {
  MyList({Key key}) : super(key: key);

  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  List<Raza> pets = [];
  Future getAll() async {
    var data = await http.get("http://localhost:1337/mascots/");
    var jsonData = json.decode(data.body);

    for (var u in jsonData) {
      pets.add(Raza(u['id'], u['name'], u['edad']));
      // pets.add(Pets(u['id'], u['name'], u['edad'], u['raza'], u['sexo']));
    }
    return pets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getAll(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                  child: Center(
                child: Text("Loading..."),
              ));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index].value),
                      subtitle: Text(snapshot.data[index].edad),
                      leading: Icon(Icons.pets),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    MyDetail(snapshot.data[index])));
                      },
                    );
                  });
            }
          }),
    );
  }
}
