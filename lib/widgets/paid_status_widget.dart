import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../theme/t_colors.dart';

class PaidStatus extends StatelessWidget {
  final bool isPaid;
  const PaidStatus({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isPaid ? Colors.green.shade200 : TColors.blue2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
      ),
      child: SizedBox(
        width: 70.0,
        height: 30.0,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              isPaid ? 'Paid' : 'Pending',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isPaid ? Colors.green.shade900 : TColors.blue,
                  fontSize: 12.0),
            ),
          ),
        ),
      ),
    );
  }
}
