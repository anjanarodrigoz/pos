import 'package:flutter/material.dart';

class DataDeletionAnimation extends StatefulWidget {
  final Widget child;
  final bool isDeleting;
  final Duration animationDuration;

  DataDeletionAnimation({
    required this.child,
    required this.isDeleting,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  _DataDeletionAnimationState createState() => _DataDeletionAnimationState();
}

class _DataDeletionAnimationState extends State<DataDeletionAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isDeleting ? 0.0 : 1.0,
      duration: widget.animationDuration,
      child: AnimatedBuilder(
        animation: widget.isDeleting
            ? CurvedAnimation(
                parent: ModalRoute.of(context)!.animation!,
                curve: Curves.easeOut,
              )
            : AlwaysStoppedAnimation(1),
        builder: (context, child) {
          return Transform.translate(
            offset:
                Offset(0, -100.0 * ModalRoute.of(context)!.animation!.value),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
