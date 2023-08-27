import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../theme/t_colors.dart';

class PaidStatus extends StatelessWidget {
  final bool isPaid;
  const PaidStatus({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isPaid ? TColors.green2 : TColors.blue2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          isPaid ? 'Paid' : 'Pending',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isPaid ? TColors.green : TColors.blue),
        ),
      ),
    );
  }
}
