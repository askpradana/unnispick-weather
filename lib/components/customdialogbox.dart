import 'package:flutter/material.dart';

class CustomDialogBox {
  void showSimpleDialog(
    BuildContext context,
    String title,
    String message,
    Function()? onPressed,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: onPressed,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
