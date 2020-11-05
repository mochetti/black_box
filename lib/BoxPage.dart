import 'package:flutter/material.dart';
import 'database.dart';
import 'Box.dart';

class BoxPage extends StatefulWidget {
  BoxPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BoxPageState createState() => _BoxPageState();
}

class _BoxPageState extends State<BoxPage> {
  Box b;

  @override
  void initState() {
    b = DatabaseMethods().getBox(4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Table(
        children: <TableRow>[
          for (int i = 0; i < 4; i++)
            new TableRow(
              children: <Text>[
                // for (int j = 0; j < 4; j++) Text(b.i[i][j].toString()),
              ],
            )
        ],
      ),
    );
  }
}
