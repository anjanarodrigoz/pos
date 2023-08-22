import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../theme/t_colors.dart';

class PaidStatus extends StatelessWidget {
  final bool isPaid;
  const PaidStatus({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        isPaid ? 'Paid' : 'Pending',
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isPaid ? TColors.green : TColors.blue),
      ),
    );
  }
}
