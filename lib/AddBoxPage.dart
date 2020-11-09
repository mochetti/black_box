import 'package:flutter/material.dart';
import 'database.dart';
import 'Box.dart';

class AddBoxPage extends StatefulWidget {
  AddBoxPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddBoxPageState createState() => _AddBoxPageState();
}

class _AddBoxPageState extends State<AddBoxPage> {
  Box box = new Box();
  Link link = new Link();
  DatabaseMethods database = new DatabaseMethods();
  List<String> abcd = ['-', 'a', 'b', 'c', 'd'];

  Future<void> confirmBoxDialog() async {
    TextEditingController userController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm your box'),
          content: Center(
            child: Column(
              children: [
                Row(
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
                                          ? Text('R')
                                          : Text(abcd[j])
                                      : j == 0
                                          ? Text(abcd[h])
                                          : h == j ||
                                                  box.res[box.mapRes[h - 1]
                                                          [j - 1]] ==
                                                      -1
                                              ? Text('-')
                                              : Text(box
                                                  .res[box.mapRes[h - 1][j - 1]]
                                                  .toStringAsFixed(2)),
                              ],
                            )
                        ],
                      ),
                    ),
                    SizedBox(width: 40),
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
                                              : Text(box
                                                  .i[box.mapI[h - 1][j - 1]]
                                                  .toStringAsFixed(2)),
                              ],
                            )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  child: TextField(
                    controller: userController,
                    decoration:
                        InputDecoration(hintText: 'your name (optional)'),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: Text('Confirm'),
                onPressed: () {
                  if (userController.text != '')
                    box.creator = userController.text;
                  database.addBox(box);
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Box'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 300,
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 100,
                      ),
                      Container(
                        child: Text(link.mapLink[index]),
                        width: 100,
                      ),
                      Container(
                        width: 200,
                        child: TextField(
                          controller: box.links[index].resController,
                          decoration: InputDecoration(hintText: 'Resistance'),
                          // inputFormatters: <TextInputFormatter>[
                          //   FilteringTextInputFormatter.digitsOnly
                          // ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      // Container(
                      //   width: 200,
                      //   child: TextField(
                      //     controller: box.links[index].capController,
                      //     decoration: InputDecoration(hintText: 'Capacitance'),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 50,
                      // ),
                      // Container(
                      //   width: 200,
                      //   child: TextField(
                      //     controller: box.links[index].indController,
                      //     decoration: InputDecoration(hintText: 'Inductance'),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 50,
                      // ),
                      Text('Diode:'),
                      DropdownButton<String>(
                        value: box.links[index].diode == 0
                            ? 'none'
                            : box.links[index].diode == 1
                                ? '->-'
                                : '-<-',
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            if (newValue == 'none')
                              box.links[index].diode = 0;
                            else if (newValue == '->-')
                              box.links[index].diode = 1;
                            else
                              box.links[index].diode = -1;
                          });
                        },
                        items: <String>['none', '->-', '-<-']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Center(child: Text('Questions')),
            // Container(
            //   height: 300,
            //   child: ListView.builder(
            //     itemCount: 6,
            //     itemBuilder: (BuildContext context, int index) {
            //       return Row(
            //         children: [
            //           SizedBox(
            //             width: 100,
            //           ),
            //           Container(
            //             child: Text(box.mapI(index * 2)),
            //             width: 100,
            //           ),
            //           Container(
            //             width: 200,
            //             child: TextField(
            //               controller: box.iControllers[index * 2],
            //               decoration: InputDecoration(hintText: 'Current ->-'),
            //               // inputFormatters: <TextInputFormatter>[
            //               //   FilteringTextInputFormatter.digitsOnly
            //               // ],
            //             ),
            //           ),
            //           SizedBox(
            //             width: 50,
            //           ),
            //           Container(
            //             child: Text(box.mapI(index * 2 + 1)),
            //             width: 100,
            //           ),
            //           Container(
            //             width: 200,
            //             child: TextField(
            //               controller: box.iControllers[index * 2 + 1],
            //               decoration: InputDecoration(hintText: 'Current -<-'),
            //             ),
            //           ),
            //         ],
            //       );
            //     },
            //   ),
            // ),
            Center(
              child: RaisedButton(
                child: Text('Submit'),
                onPressed: () {
                  for (int i = 0; i < box.links.length; i++) {
                    // if (box.links[i].capController.text == '')
                    //   box.links[i].capController.text = '0',
                    // if (box.links[i].indController.text == '')
                    //   box.links[i].indController.text = '0',
                    if (box.links[i].resController.text == '')
                      box.res[i] = -1;
                    else
                      box.res[i] =
                          double.parse(box.links[i].resController.text);
                    // if (box.iControllers[2 * i].text == '')
                    //   box.i[2 * i] = '0'
                    // else
                    //   box.i[2 * i] = box.iControllers[2 * i].text,
                    // if (box.iControllers[2 * i + 1].text == '')
                    //   box.i[2 * i + 1] = '0'
                    // else
                    //   box.i[2 * i + 1] = box.iControllers[2 * i + 1].text,
                  }
                  box.calculateR();
                  box.calculateI(5.0);
                  confirmBoxDialog();
                  // DatabaseMethods().addBox(box),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (int i = 0; i < box.links.length; i++) {
      box.links[i].capController.dispose();
      box.links[i].indController.dispose();
      box.links[i].resController.dispose();
    }
    super.dispose();
  }
}
