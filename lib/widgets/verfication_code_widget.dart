import 'package:flutter/material.dart';

class VerificationCodeInput extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;

  const VerificationCodeInput(
      {super.key, required this.length, required this.onCompleted});

  @override
  _VerificationCodeInputState createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );

    // Add listeners to text controllers
    for (int i = 0; i < widget.length; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text.length == 1) {
          if (i < widget.length - 1) {
            // Move focus to the next text field
            FocusScope.of(context).requestFocus(focusNodes[i + 1]);
          } else {
            // The last text field has been filled, trigger onCompleted
            String code =
                controllers.map((controller) => controller.text).join();
            widget.onCompleted(code);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.length; i++) {
      controllers[i].dispose();
      focusNodes[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.length,
        (index) => SizedBox(
          width: 50.0,
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
