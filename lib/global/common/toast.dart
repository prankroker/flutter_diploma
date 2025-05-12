import 'package:flutter/material.dart';

void showToast({required BuildContext context,required String message}){
  ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Прибирає попередній
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.cyan,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}