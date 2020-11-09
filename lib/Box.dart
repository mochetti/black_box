import 'package:flutter/material.dart';

class Box {
  int id;
  String creator = 'anonymous';
  int pop = 0;
  bool diode = false; // Indicates if there is a diode
  bool ac =
      false; // Indicates if there are AC elements (ie. inductors, capacitors)
  List<Link> links = [];
  // ab, ba, ac, ca, ad, da, bc, cb, bd, db, cd, dc
  List<double> i = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<double> resOut = [-1, -1, -1, -1, -1, -1];
  List<double> res = [-1, -1, -1, -1, -1, -1];

  // List<List<double>> cap = [
  //   [-1, -1, -1, -1],
  //   [-1, -1, -1, -1],
  //   [-1, -1, -1, -1],
  //   [-1, -1, -1, -1],
  // ];
  // List<List<double>> ind = [
  //   [-1, -1, -1, -1],
  //   [-1, -1, -1, -1],
  //   [-1, -1, -1, -1],
  //   [-1, -1, -1, -1],
  // ];

  // ab, ba, ac, ca, ad, da, bc, cb, bd, db, cd, dc
  List<TextEditingController> iControllers = [];

  // String mapLinkName(int index) {
  //   final List<String> map = [
  //     'ab',
  //     'ba',
  //     'ac',
  //     'ca',
  //     'ad',
  //     'da',
  //     'bc',
  //     'cb',
  //     'bd',
  //     'db',
  //     'cd',
  //     'dc'
  //   ];
  //   return map[index];
  // }

  List<List<int>> mapRes = [
    [-1, 0, 1, 2],
    [0, -1, 3, 4],
    [1, 3, -1, 5],
    [2, 4, 5, -1]
  ];

  List<List<int>> mapI = [
    [-1, 0, 2, 4],
    [1, -1, 6, 8],
    [3, 7, -1, 10],
    [5, 9, 11, -1]
  ];

  List<List<int>> triangles = [
    [0, 1, 3],
    [0, 2, 4],
    [3, 4, 5],
    [1, 2, 5]
  ];
  int completeTriangle(int a, int b) {
    int c, d, indexC, indexD;
    if (a < b) {
      c = a;
      d = b;
    } else {
      c = b;
      d = a;
    }
    for (int i = 0; i < 4; i++) {
      indexC = -1;
      for (int j = 0; j < 3; j++) {
        if (triangles[i][j] == c) indexC = j;
        if (triangles[i][j] == d && indexC != -1) {
          indexD = j;
          return triangles[i][3 - indexC - indexD];
        }
      }
    }
    print('triangle $a $b not found');
    return null;
  }

  List<List<int>> vertices = [
    [0, 1, 2],
    [0, 3, 4],
    [1, 3, 5],
    [2, 4, 5]
  ];
  int completeVertice(int a, int b) {
    // print('completing $a $b');
    int indexA, indexB;
    for (int i = 0; i < 4; i++) {
      indexA = -1;
      for (int j = 0; j < 3; j++) {
        if (vertices[i][j] == a) indexA = j;
        if (vertices[i][j] == b && indexA != -1) {
          indexB = j;
          // print('completed with ${vertices[i][3 - indexA - indexB]}');
          return vertices[i][3 - indexA - indexB];
        }
      }
    }
    print('vertice $a $b not found');
    return null;
  }

  // Generate i array from resOut values and v voltage
  calculateI(double v) {
    // Check if the box is pure resistive
    if (diode == true || ac == true) return;
    for (int j = 0; j < resOut.length; j++) {
      if (resOut[j] != -1) {
        i[2 * j] = v / resOut[j];
        i[2 * j + 1] = v / resOut[j];
      }
    }
    // print(i);
  }

  // Generate resOut array from given inputs
  calculateR() {
    // Check if the box is pure resistive
    if (diode == true || ac == true) return;

    // Copy original to output
    for (int i = 0; i < res.length; i++) resOut[i] = res[i];

    // Check how many resistors there are
    int sum = 0;
    for (int i = 0; i < res.length; i++) if (res[i] != -1) sum++;
    switch (sum) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        final List<List<int>> map = [
          [-1, 3, 4, 1, 2, -1],
          [3, -1, 5, 0, -1, 2],
          [4, 5, -1, -1, 0, 1],
          [1, 0, -1, -1, 5, 4],
          [2, -1, 0, 5, -1, 3],
          [-1, 2, 1, 4, 3, -1]
        ];
        for (int i = 0; i < 6; i++)
          for (int j = 0; j < 6; j++)
            if (res[i] != -1 && res[j] != -1 && map[i][j] != -1)
              resOut[map[i][j]] = res[i] + res[j];
        break;
      case 3:
        // Find three resistors
        int a = -1, b = -1, c = -1;
        for (int i = 0; i < 6; i++) {
          if (res[i] != -1) {
            if (a == -1)
              a = i;
            else if (b == -1)
              b = i;
            else
              c = i;
          }
        }
        // Calculate each resistor
        for (int i = 0; i < 6; i++) resOut[i] = calc3res(i, a, b, c);
        break;
      case 4:
        // Find the missing resistors
        int a = -1, b = -1;
        for (int i = 0; i < 6; i++) {
          if (res[i] == -1) {
            if (a == -1) {
              a = i;
            } else if (b == -1) {
              b = i;
            }
          }
        }
        // Calculate each resistor
        for (int i = 0; i < 6; i++) resOut[i] = calc4res(i, a, b);

        break;
      case 5:
        // Find which resistor is missing
        int r = -1;
        for (int i = 0; i < 6; i++) if (res[i] == -1) r = i;
        // Calculate each resistor
        for (int i = 0; i < 6; i++) resOut[i] = calc5res(i, r);
        break;
      case 6:
        for (int i = 0; i < 6; i++) resOut[i] = calc6res(i);
        break;
    }
    print(resOut);
  }

  double parallel(double a, double b) {
    if (a == -1 && b != -1) return b;
    if (a != -1 && b == -1) return a;
    return a * b / (a + b);
  }

  // Returns equivalent res for i link for a,b,c resistor
  double calc3res(int i, int a, int b, int c) {
    // Check if a,b,c form a triangle
    if (a == 0 && b == 1 && c == 3 ||
        a == 0 && b == 2 && c == 4 ||
        a == 1 && b == 2 && c == 5 ||
        a == 3 && b == 4 && c == 5) {
      print('triangle found !');
      if (i == a)
        return parallel(res[a], res[b] + res[c]);
      else if (i == b)
        return parallel(res[b], res[a] + res[c]);
      else if (i == c)
        return parallel(res[c], res[a] + res[b]);
      else
        return res[i];
    }
    // Check if a,b,c share a vertice
    if (a == 0 && b == 1 && c == 2 ||
        a == 0 && b == 3 && c == 4 ||
        a == 1 && b == 3 && c == 5 ||
        a == 2 && b == 4 && c == 5) {
      print('vertice found !');
      print('$i $a $b ${completeTriangle(a, b)}');
      if (i == completeTriangle(a, b))
        return (res[a] + res[b]).toDouble();
      else if (i == completeTriangle(a, c))
        return (res[a] + res[c]).toDouble();
      else if (i == completeTriangle(b, c))
        return (res[b] + res[c]).toDouble();
      else
        return res[i];
    }
    // a,b,c must form a sequence
    print('sequence found !');
    // Check which is the middle resistor
    if (b != 5 - a && c != 5 - a) {
      print('$a is in the middle');
      if (i == 5 - a)
        return (res[a] + res[b] + res[c]).toDouble();
      else if (i == completeTriangle(a, b))
        return (res[a] + res[b]).toDouble();
      else if (i == completeTriangle(a, c)) return (res[a] + res[c]).toDouble();
    }
    if (a != 5 - b && c != 5 - b) {
      print('$b is in the middle');
      if (i == 5 - b)
        return (res[a] + res[b] + res[c]).toDouble();
      else if (i == completeTriangle(a, b))
        return (res[a] + res[b]).toDouble();
      else if (i == completeTriangle(b, c)) return (res[b] + res[c]).toDouble();
    }
    if (a != 5 - c && b != 5 - c) {
      print('$c is in the middle');
      if (i == 5 - c)
        return (res[a] + res[b] + res[c]).toDouble();
      else if (i == completeTriangle(a, c))
        return (res[a] + res[c]).toDouble();
      else if (i == completeTriangle(b, c)) return (res[b] + res[c]).toDouble();
    }
    return res[i];
  }

  // Returns equivalent res for link i if only a,b resistors are not present
  double calc4res(int i, int a, int b) {
    // Check if the missing are opposite
    if (a == 5 - b) {
      if (i == a || i == b) {
        print('$i equals missing opposites');
        // Check which triangles does i belong to
        int t1 = -1, t2 = -1;
        double s1, s2;
        for (int j = 0; j < 3; j++)
          for (int k = 0; k < 3; k++)
            if (triangles[j][k] == i) {
              if (t1 == -1)
                t1 = j;
              else
                t2 = j;
            }
        for (int j in triangles[t1]) s1 += res[j];
        for (int j in triangles[t2]) s2 += res[j];
        return parallel(s1 - res[i], s2 - res[i]);
      } else {
        print('missing are opposite');
        double aux = 0;
        for (double r in res) aux += r;
        aux -= res[a];
        aux -= res[b];
        aux -= res[i];
        return parallel(res[i], aux);
      }
    }
    // Check if i,a,b share a vertice
    if (i == completeVertice(a, b)) {
      print('$i and missing share a vertice');
      return res[i];
    }

    if (i == a || i == b) {
      print('$i missing (x+y)//z + w');
      final List<List<int>> map = [
        [-1, 3, 4, 1, 2, -1],
        [3, -1, 5, 0, -1, 2],
        [4, 5, -1, -1, 0, 1],
        [1, 0, -1, -1, 5, 4],
        [2, -1, 0, 5, -1, 3],
        [-1, 2, 1, 4, 3, -1]
      ];
      int v = completeVertice(a, b);
      if (i == a)
        return parallel(res[map[a][b]] + res[completeTriangle(b, v)],
                res[completeTriangle(a, v)]) +
            res[v];
      else if (i == b)
        return parallel(res[map[a][b]] + res[completeTriangle(a, v)],
                res[completeTriangle(b, v)]) +
            res[v];
    }
    // Get triangle thats left
    print('$i is in left triangle');
    int v = completeVertice(a, b);
    double t = 0;
    for (int j = 0; j < 6; j++) t += res[j];
    t -= res[a];
    t -= res[b];
    t -= res[v];
    t -= res[i];
    return parallel(res[i], t);
  }

  // Returns equivalent res for link i if only r resistor is not present
  double calc5res(int i, int r) {
    List<List<List<int>>> map = [
      [
        // AB
        [0, 0, 0, 0, 0], // itself
        [0, 3, 5, 4, 2], // AC = -1
        [0, 4, 5, 2, 1], // AD = -1
        [0, 1, 5, 2, 4], // BC = -1
        [0, 2, 5, 1, 3], // BD = -1
        [0, 1, 3, 2, 4], // opposite
      ],
      [
        // AC
        [1, 3, 4, 5, 2], // AB = -1
        [0, 0, 0, 0, 0], // itself
        [1, 4, 5, 3, 0], // AD = -1
        [1, 0, 4, 2, 5], // BC = -1
        [1, 0, 3, 2, 5], // opposite
        [1, 2, 4, 0, 3], // CD = -1
      ],
      [
        // AD
        [2, 3, 4, 5, 1], // AB = -1
        [2, 3, 5, 4, 0], // AC = -1
        [0, 0, 0, 0, 0], // itself
        [2, 0, 4, 1, 5], // opposite
        [2, 0, 3, 1, 5], // BD = -1
        [2, 1, 3, 0, 4], // CD = -1
      ],
      [
        // BC
        [3, 1, 2, 5, 4], // AB = -1
        [3, 0, 2, 4, 5], // AC = -1
        [3, 0, 1, 4, 5], // opposite
        [0, 0, 0, 0, 0], // itself
        [3, 2, 5, 1, 0], // BD = -1
        [3, 2, 4, 0, 1], // CD = -1
      ],
      [
        // BD
        [4, 1, 2, 0, 3], // AB = -1
        [4, 0, 2, 3, 5], // opposite
        [4, 0, 1, 3, 5], // AD = -1
        [4, 1, 5, 2, 0], // BC = -1
        [0, 0, 0, 0, 0], // itself
        [4, 1, 3, 0, 2], // CD = -1
      ],
      [
        // CD
        [5, 1, 2, 3, 4], // opposite
        [5, 0, 2, 4, 3], // AC = -1
        [5, 0, 1, 3, 4], // AD = -1
        [5, 0, 4, 2, 1], // BC = -1
        [5, 0, 3, 1, 2], // BD = -1
        [0, 0, 0, 0, 0], // itself
      ],
    ];

    // Check if itself is missing
    if (i == r) return calc6res(i);
    // Check if the opposite is missing
    if (i == 5 - r) {
      double aux1 = res[map[i][r][1]] + res[map[i][r][3]];
      double aux2 = res[map[i][r][2]] + res[map[i][r][4]];
      double aux3 = parallel(aux1, aux2);
      return parallel(res[map[i][r][0]], aux3);
    } else {
      double aux1 = res[map[i][r][1]] + res[map[i][r][2]];
      double aux2 = parallel(aux1, res[map[i][r][3]]) + res[map[i][r][4]];
      return parallel(res[map[i][r][0]], aux2);
    }
  }

  // Returns equivalent res for link i if all 6 resistors are present
  double calc6res(int i) {
    final List<List<int>> map = [
      [0, 1, 2, 3, 4, 5],
      [1, 3, 5, 0, 2, 4],
      [2, 4, 5, 0, 1, 3],
      [3, 4, 0, 5, 1, 2],
      [4, 3, 0, 5, 2, 1],
      [5, 1, 3, 2, 4, 0]
    ];
    double t = res[map[i][3]] + res[map[i][4]] + res[map[i][5]];
    double aux1 = res[map[i][3]] * res[map[i][5]] / t + res[map[i][1]];
    double aux2 = res[map[i][4]] * res[map[i][5]] / t + res[map[i][2]];
    double aux3 = parallel(aux1, aux2) + res[map[i][3]] * res[map[i][4]] / t;
    return parallel(res[map[i][0]], aux3);
  }

  Box() {
    links = List.generate(6, (index) => new Link());
    iControllers = List.generate(12, (index) => new TextEditingController());
  }
}

class Link {
  TextEditingController capController = new TextEditingController();
  TextEditingController indController = new TextEditingController();
  TextEditingController resController = new TextEditingController();
  int diode = 0;
  Link();

  List<String> mapLink = [
    'ab',
    'ac',
    'ad',
    'bc',
    'bd',
    'cd',
  ];
}
