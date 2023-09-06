import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlertMessage {
  static snakMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            // add your preferred icon here
            Text(
              message,
              style: const TextStyle(fontSize: 15.0),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
