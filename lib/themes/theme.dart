import 'package:flutter/material.dart';

ThemeData buildAppTheme(){
  return ThemeData(
      primarySwatch: Colors.cyan,
      textButtonTheme:TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.black, width: 1)
          ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          side: const BorderSide(color: Colors.black, width: 1),
            minimumSize: const Size(200,48)
        )
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius:  BorderRadius.circular(10.0),
        ),
      )
  );
}