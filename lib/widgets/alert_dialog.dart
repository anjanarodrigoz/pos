import 'package:flutter/material.dart';

class POSAleartDialog extends StatelessWidget {
  final String title;
  final String content;
  final String close;
  final String textContine;
  final Color color;
  final Function()? onClose;
  final Function()? onCountinue;

  const POSAleartDialog(
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
