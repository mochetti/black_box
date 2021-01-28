import 'package:flutter/material.dart';
import 'database.dart';
import 'Box.dart';

class BoxPage extends StatefulWidget {
  BoxPage({Key key, this.box}) : super(key: key);

  final Box box;

  @override
  _BoxPageState createState() => _BoxPageState();
}

class _BoxPageState extends State<BoxPage> {
  Link link = new Link();
  bool isLoading = true;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  List<TextEditingController> controllers =
      List.generate(6, (index) => new TextEditingController());
  List<String> abcd = ['-', 'a', 'b', 'c', 'd'];
  bool gaveLove = false;

  @override
  void initState() {
    loadBox();
    super.initState();
  }

  void loadBox() async {
    // print(widget.box.res);
    // print(widget.box.i);
    // box.calculateR();
    // box.calculateI(5.0);
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
              title: Text('Box ${widget.box.id}'),
            ),
            body: Column(
              children: [
                Center(
                  child: Text('Voltage = 5V'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // height: 200,
                      width: 200,
                      child: Table(
                        children: <TableRow>[
                          for (int h = 0; h < 5; h++)
                            new TableRow(
                              children: <Text>[
                                for (int j = 0; j < 5; j++)
                                  h == 0
                                      ? j == 0
                                          ? Text('I')
                                          : Text(abcd[j])
                                      : j == 0
                                          ? Text(abcd[h])
                                          : h == j
                                              ? Text('-')
                                              : Text(widget
                                                  .box
                                                  .i[widget.box.mapI[h - 1]
                                                      [j - 1]]
                                                  .toStringAsFixed(2)),
                              ],
                            )
                        ],
                      ),
                    ),
                    SizedBox(width: 50),
                    Column(
                      children: [
                        for (int i = 0; i < 6; i++)
                          Container(
                            width: 200,
                            child: TextField(
                              decoration:
                                  InputDecoration(hintText: link.mapLink[i]),
                              controller: controllers[i],
                            ),
                          ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 50),
                RaisedButton(
                  child: Text('Check'),
                  onPressed: () {
                    bool check = true;
                    for (int j = 0; j < 6; j++)
                      if (controllers[j].text == '') controllers[j].text = '-1';
                    for (int j = 0; j < 6; j++)
                      if (controllers[j].text != widget.box.res[j].toString())
                        check = false;
                    checkAlert(check);
                  },
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Pop: ${widget.box.pop}'),
                    SizedBox(width: 50),
                    RaisedButton(
                      child: Text('+1'),
                      onPressed: gaveLove
                          ? null
                          : () {
                              databaseMethods.addPop(widget.box.id);
                              setState(() {
                                widget.box.pop++;
                                gaveLove = true;
                              });
                            },
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Future<void> checkAlert(bool check) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: check == true ? Text('Success!') : Text('Ooops...'),
            content: check == true
                ? Text('Values match! Keep up the good work!')
                : Text('Check your values and try again!'),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
