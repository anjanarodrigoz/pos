import 'package:flutter/material.dart';
import 'package:pos/widgets/pos_text_form_field.dart';

class POSVerifyDialog extends StatefulWidget {
  final String title;
  final String content;
  final String close;
  final String continueText;
  final String verifyText;
  final Color color;
  final Function()? onClose;
  final Function()? onContinue;

  POSVerifyDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onContinue,
    this.onClose,
    this.color = Colors.red,
    this.close = 'Close',
    required this.verifyText,
    required this.continueText,
  }) : super(key: key);

  @override
  _POSVerifyDialogState createState() => _POSVerifyDialogState();
}

class _POSVerifyDialogState extends State<POSVerifyDialog> {
  TextEditingController _textController = TextEditingController();
  bool isTextValid = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.red.shade900),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.content),
          const SizedBox(
            height: 10.0,
          ),
          PosTextFormField(
            height: 70.0,
            controller: _textController,
            labelText: 'Enter hint text',
            hintText: widget.verifyText,
            errorText: isTextValid ? null : 'Text doesn\'t match',
          ),
          const SizedBox(height: 10),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            String enteredText = _textController.text.trim();
            if (enteredText == widget.verifyText) {
              widget.onContinue?.call();
            } else {
              setState(() {
                isTextValid = false;
              });
            }
          },
          child: Text(
            widget.continueText,
            style: TextStyle(color: widget.color),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onClose?.call();
            Navigator.of(context).pop();
          },
          child: Text(widget.close),
        )
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
