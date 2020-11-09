import 'package:cloud_firestore/cloud_firestore.dart';
import 'Box.dart';

class DatabaseMethods {
  Future<Box> getBox(int id) async {
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
    box.id = snap.get('id');
    box.creator = snap.get('creator');
    box.pop = snap.get('pop');
    box.i = [];
    for (int i = 0; i < 12; i++) box.i.add(snap.get('i')[i]);

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

    for (int i = 0; i < 6; i++) {
      box.res[i] = query.docs[i].get('res');
    }
    return box;
  }

  // Return most popular boxes by 'pop' field
  getPop() async {
    List<Box> popBoxes = [];
    int qnt = await getQnt();
    // Get ids
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('boxes')
        .orderBy('pop', descending: true)
        .limit(5)
        .get()
        .catchError((e) {
      print(e);
    });
    // Get boxes
    if (qnt > 5) qnt = 5;
    for (int i = 0; i < qnt; i++) {
      popBoxes.add(await getBox(int.parse(query.docs[i].id)));
    }
    return popBoxes;
  }

  // Return last added boxes as array
  getLast() async {
    // Get last box id
    int qnt = await getQnt();
    List<Box> lastBoxes = [];
    // Get boxes
    for (int i = 0; i < qnt; i++) {
      lastBoxes.add(await getBox(qnt - i - 1));
    }
    return lastBoxes;
  }

  // Add 1 in pop field
  addPop(int id) async {
    // Get current pop
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('boxes')
        .doc(id.toString())
        .get()
        .catchError((e) {
      print(e);
    });
    await FirebaseFirestore.instance
        .collection('boxes')
        .doc(id.toString())
        .update({
      'pop': doc.get('pop') + 1,
    }).catchError((e) {
      print(e);
    });
  }

  addBox(Box box) async {
    // Get current boxes length
    int id = await getQnt();

    // Check for diodes
    // bool diode = false;
    // for (Link link in box.links) if (link.diode != 0) diode = true;

    // Check for AC elements
    // bool ac = false;
    // for (Link link in box.links)
    //   if (link.capController.text != '0' || link.indController.text != '0')
    //     ac = true;

    // Create box document
    await FirebaseFirestore.instance
        .collection('boxes')
        .doc(id.toString())
        .set({
      'diode': box.diode,
      'ac': box.ac,
      'i': box.i,
      'id': id,
      'creator': box.creator,
      'pop': 0,
    }).catchError((e) {
      print('error addBox: $e');
    });

    // Add each link
    for (int i = 0; i < box.links.length; i++)
      await setLink(
          doc: id,
          link: i,
          diode: box.links[i].diode,
          // double.parse(box.links[i].capController.text),
          // double.parse(box.links[i].indController.text),
          res: double.parse(box.links[i].resController.text));

    // Increase boxes length by one
    setQnt(id + 1);
  }

  setLink(
      {int doc,
      int link,
      int diode,
      double cap,
      double ind,
      double res}) async {
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
      // 'cap': cap,
      // 'ind': ind,
      'res': res,
    }).catchError((e) {
      print('error set link: $e');
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
