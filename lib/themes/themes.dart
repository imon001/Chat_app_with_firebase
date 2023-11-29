import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepOrange,
    foregroundColor: Colors.black87,
    centerTitle: false,
    elevation: 3,
  ),
  //colorSchemeSeed: Colors.purple,
  colorScheme: ColorScheme.light(
    background: Colors.deepOrange.shade50,
    onBackground: Colors.deepOrange.shade100,
    primary: Colors.deepOrange.shade300,
    secondary: Colors.deepOrange.shade500,
    onSecondary: Colors.purple.shade200,
    onPrimary: Colors.black87, //for text color
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

ThemeData darkMode = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blueGrey.shade900,
    foregroundColor: Colors.white70,
    centerTitle: false,
    elevation: 3,
  ),
  brightness: Brightness.dark,
  //colorSchemeSeed: Colors.grey,
  colorScheme: ColorScheme.dark(
    background: Colors.blueGrey.shade800,
    primary: Colors.blueGrey.shade700,
    secondary: Colors.blueGrey.shade500,
    onSecondary: Colors.grey.shade600,

    onPrimary: Colors.white70, //for text color
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);
