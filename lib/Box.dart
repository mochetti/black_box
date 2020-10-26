import 'package:flutter/material.dart';

class Box {
  bool diode = false; // Indicates if there is a diode
  bool ac =
      false; // Indicates if there are AC elements (ie. inductors, capacitors)
  List<List<double>> res = [
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 1]
  ];
  List<List<double>> cap = [
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 1]
  ];
  List<List<double>> ind = [
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 1]
  ];
  List<List<double>> i = [
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0]
  ];

  Box();

  calculateI() {
    if (ac == false) {
      if (diode == false) {
        for (int y = 0; y < 4; y++) {
          for (int x = 0; x < 4; x++) {
            if (x == y)
              i[y][x] = -1;
            else
              i[y][x] = 5.0 / res[y][x];
          }
        }
      }
    }
    print(i);
  }
}

class Link {
  TextEditingController capController = new TextEditingController();
  TextEditingController indController = new TextEditingController();
  TextEditingController resController = new TextEditingController();
  int diode = 0;
  Link();
}
