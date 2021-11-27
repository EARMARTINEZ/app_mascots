import 'package:flutter/material.dart';
import 'user.dart';
import '../app.dart';
import 'package:http/http.dart' as http;

class MyDetail extends StatefulWidget {
  Pets pets;
  MyDetail(this.pets);
  @override
  _MyDetailState createState() => _MyDetailState(this.pets);
}

class _MyDetailState extends State<MyDetail> {
  Pets pets;
  _MyDetailState(this.pets);
  void edit() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Home(0, pets.id)));
  }

  void delete() async {
    await http.delete("http://localhost:1337/mascots/${this.pets.id}");
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Home(1, 0)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text(pets.name)),
          body: Container(
              child: Padding(
            padding: EdgeInsets.all(19.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(19),
                  child: Text(
                    "Id: " + pets.id.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(19),
                  child: Text(
                    "Name: " + pets.name,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(19),
                  child: Text(
                    "Edad: " + pets.edad,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Row(
                  children: [
                    MaterialButton(
                      onPressed: edit,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text("Edit"),
                    ),
                    Spacer(),
                    MaterialButton(
                      onPressed: delete,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text("Delete"),
                    ),
                  ],
                )
              ],
            ),
          ))),
    );
  }
}
