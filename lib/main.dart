import 'package:black_box/AddBoxPage.dart';
import 'package:flutter/material.dart';
import 'BoxPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AddBoxPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Black Box',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Box'),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BoxPage()),
                )
              },
            ),
            RaisedButton(
              child: Text('Add Box'),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddBoxPage()),
                )
              },
            )
          ],
        ),
      ),
    );
  }
}
