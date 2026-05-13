import 'package:flutter/material.dart';

class EmptyPlanner extends StatelessWidget {
  const EmptyPlanner({super.key});

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(
            Icons.calendar_month,
            size: 60,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 14),

          Text(
            "No outfits yet",

            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}