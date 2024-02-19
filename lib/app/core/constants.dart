import 'package:flutter/material.dart';

class Planets {
  static int get totalSize {
    return leftCorner.length + rightCorner.length + back.length + front.length;
  }

  static final List<String> leftCorner = ["Mercúrio"];
  static final List<String> back = ["Marte", "Júpiter", "Saturno"];
  static final List<String> rightCorner = ["Vênus"];
  static final List<String> front = ["Terra", "Urano", "Netuno"];

  ///netuno -> Ponta direita
  ///remover
}

List<Color> planetListColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.amber,
  Colors.purple,
  Colors.orange,
  Colors.lime,
  Colors.pinkAccent,
];

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
