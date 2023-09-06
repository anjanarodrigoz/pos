import 'package:flutter/material.dart';

class POSAleartDialog extends StatelessWidget {
  String title;
  String content;
  String close;
  String textContine;
  Color color;
  Function()? onClose;
  Function()? onCountinue;

  POSAleartDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.onCountinue,
      this.onClose,
      this.color = Colors.blue,
      this.close = 'Close',
      required this.textContine});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: onCountinue,
            child: Text(
              textContine,
              style: TextStyle(color: color),
            )),
        TextButton(
            onPressed: () {
              onClose;
              Navigator.of(context).pop();
            },
            child: Text(close))
      ],
    );
  }
}
