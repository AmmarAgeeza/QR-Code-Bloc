import 'package:flutter/material.dart';


void showSnackBar({required String message, required BuildContext context}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
