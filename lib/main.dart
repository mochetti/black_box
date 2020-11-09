import 'package:black_box/AddBoxPage.dart';
import 'package:black_box/database.dart';
import 'package:flutter/material.dart';
import 'BoxPage.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddBoxPage.dart';
import 'Box.dart';

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
      home: MyHomePage(title: 'Black Box'),
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
  DatabaseMethods databaseMethods = DatabaseMethods();
  List<Box> popBoxes = [];
  List<Box> lastBoxes = [];
  bool isLoading = true;

  @override
  void initState() {
    // load boxes
    loadData();
    super.initState();
  }

  // load boxes ids
  void loadData() async {
    // load last added boxes
    lastBoxes = await databaseMethods.getLast();
    // load most popular boxes
    popBoxes = await databaseMethods.getPop();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Last boxes'),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: lastBoxes.length,
                      itemBuilder: (context, index) {
                        return TextButton(
                          child: Text(
                              'Box ${lastBoxes[index].id}\nby: ${lastBoxes[index].creator}'),
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BoxPage(box: lastBoxes[index])),
                            )
                          },
                        );
                      },
                    ),
                  ),
                  Text('Pop Boxes'),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popBoxes.length,
                      itemBuilder: (context, index) {
                        return TextButton(
                          child: Text(
                              'Box ${popBoxes[index].id}\nby: ${popBoxes[index].creator}'),
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BoxPage(box: popBoxes[index])),
                            )
                          },
                        );
                      },
                    ),
                  ),
                  RaisedButton(
                    child: Text('Add Box'),
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddBoxPage()),
                      )
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text('Welcome to the Black Box web app\n'),
                ],
              ),
            ),
          );
  }
}
