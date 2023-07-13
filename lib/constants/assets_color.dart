import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AssetsColor {
  static Color primary = HexColor("#173B56");
  static Color secondary = HexColor("#0FA2A7");
  static Color greyYoung = HexColor("#BECEC0");
  static Color white = HexColor("#FAF6F0");
  static Color grey = HexColor("#C6C7C7");
  static Color black = HexColor("#181a18");
  static Color red = HexColor("#F47174");

  ///Fungsi untuk mengubah Color ke MaterialColor
  ///
  ///Fungsi ini mengembalikan MaterialColor
  ///
  ///Contoh:
  ///
  ///```dart
  ///MaterialColor color = AssetsColor.getMaterialColor(Colors.blue);
  ///```
  static MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
  }
}
