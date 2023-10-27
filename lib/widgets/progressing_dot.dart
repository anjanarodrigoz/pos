import 'dart:async';
import 'package:flutter/material.dart';

class ProgressingDots extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Duration dotDuration;
  final int maxDots;

  ProgressingDots({
    required this.text,
    this.textStyle = const TextStyle(fontSize: 14),
    this.dotDuration = const Duration(seconds: 1),
    this.maxDots = 3,
  });

  @override
  _ProgressingDotsState createState() => _ProgressingDotsState();
}

class _ProgressingDotsState extends State<ProgressingDots> {
  String dots = '';
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Start the timer to add dots
    timer = Timer.periodic(widget.dotDuration, (timer) {
      setState(() {
        // Add a dot to the existing dots, and reset when reaching the max dots
        dots = (dots.length < widget.maxDots)
            ? dots + '.'
            : widget.text.length > widget.maxDots
                ? '.'
                : '';
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the timer when the widget is disposed
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          Text(
            widget.text,
            style: widget.textStyle,
          ),
          Text(dots, style: widget.textStyle),
        ],
      ),
    );
  }
}
