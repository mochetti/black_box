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
  List<Link> links = List.generate(6, (index) => new Link());
  final List<String> map = [
    'ab',
    'ac',
    'ad',
    'bc',
    'bd',
    'cd',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Box'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  SizedBox(
                    width: 100,
                  ),
                  Container(
                    child: Text(map[index]),
                    width: 100,
                  ),
                  Container(
                    width: 200,
                    child: TextField(
                      controller: links[index].resController,
                      decoration: InputDecoration(hintText: 'Resistance'),
                      // inputFormatters: <TextInputFormatter>[
                      //   FilteringTextInputFormatter.digitsOnly
                      // ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Container(
                    width: 200,
                    child: TextField(
                      controller: links[index].capController,
                      decoration: InputDecoration(hintText: 'Capacitance'),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Container(
                    width: 200,
                    child: TextField(
                      controller: links[index].indController,
                      decoration: InputDecoration(hintText: 'Inductance'),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Text('Diode:'),
                  DropdownButton<String>(
                    value: links[index].diode == 0
                        ? 'none'
                        : links[index].diode == 1
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
                          links[index].diode = 0;
                        else if (newValue == '->-')
                          links[index].diode = 1;
                        else
                          links[index].diode = -1;
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
          Center(
            child: RaisedButton(
              child: Text('Submit'),
              onPressed: () => {
                for (int i = 0; i < links.length; i++)
                  {
                    if (links[i].capController.text == '')
                      links[i].capController.text = '0',
                    if (links[i].indController.text == '')
                      links[i].indController.text = '0',
                    if (links[i].resController.text == '')
                      links[i].resController.text = '0',
                  },
                DatabaseMethods().addBox(links),
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (int i = 0; i < links.length; i++) {
      links[i].capController.dispose();
      links[i].indController.dispose();
      links[i].resController.dispose();
    }
    super.dispose();
  }
}
