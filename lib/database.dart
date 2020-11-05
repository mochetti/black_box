import 'package:cloud_firestore/cloud_firestore.dart';
import 'Box.dart';

class DatabaseMethods {
  getBox(int id) async {
    Box box = new Box();

    // Get box properties
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('boxes')
        .doc(id.toString())
        .get()
        .catchError((e) {
      print(e);
    });

    box.ac = snap.get('ac');
    box.diode = snap.get('diode');

    // Get links
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('boxes')
        .doc(id.toString())
        .collection('links')
        .get()
        .catchError((e) {
      print(e);
    });

    // // Get query.docs[i] from box.res(i,j)
    // List<List<int>> decode = [
    //   [-1, 0, 1, 2],
    //   [0, -1, 3, 4],
    //   [1, 3, -1, 5],
    //   [2, 4, 5, -1]
    // ];

    // for (int i = 0; i < 4; i++) {
    //   for (int j = 0; j < 4; j++) {
    //     box.res[i][j] = query.docs[decode[i][j]].get('res');
    //     box.cap[i][j] = query.docs[decode[i][j]].get('cap');
    //     box.ind[i][j] = query.docs[decode[i][j]].get('ind');
    //   }
    // }

    return box;
  }

  addBox(Box box) async {
    // Get current boxes length
    int id = await getQnt();

    // Check for diodes
    bool diode = false;
    for (Link link in box.links) if (link.diode != 0) diode = true;

    // Check for AC elements
    bool ac = false;
    for (Link link in box.links)
      if (link.capController.text != '0' || link.indController.text != '0')
        ac = true;

    // Create box document
    await FirebaseFirestore.instance
        .collection('boxes')
        .doc(id.toString())
        .set({
      'diode': diode,
      'ac': ac,
      'i': box.i,
    }).catchError((e) {
      print(e);
    });

    // Add each link
    for (int i = 0; i < box.links.length; i++)
      await setLink(
          id,
          i,
          box.links[i].diode,
          double.parse(box.links[i].capController.text),
          double.parse(box.links[i].indController.text),
          double.parse(box.links[i].resController.text));

    // Increase boxes length by one
    setQnt(id + 1);
  }

  setLink(
      int doc, int link, int diode, double cap, double ind, double res) async {
    final List<String> map = [
      'ab',
      'ac',
      'ad',
      'bc',
      'bd',
      'cd',
    ];
    await FirebaseFirestore.instance
        .collection('boxes')
        .doc(doc.toString())
        .collection('links')
        .doc(map[link])
        .set({
      'diode': diode,
      'cap': cap,
      'ind': ind,
      'res': res,
    }).catchError((e) {
      print(e);
    });
  }

  Future<int> getQnt() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('utils')
        .doc('boxes')
        .get()
        .catchError((e) {
      print(e);
    });
    return snap.get('qnt');
  }

  setQnt(int qnt) async {
    await FirebaseFirestore.instance
        .collection('utils')
        .doc('boxes')
        .set({'qnt': qnt}).catchError((e) {
      print(e);
    });
  }
}
