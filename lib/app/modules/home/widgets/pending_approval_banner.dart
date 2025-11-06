// app/modules/home/widgets/pending_approval_banner.dart

import 'package:flutter/material.dart';

class PendingApprovalBanner extends StatelessWidget {
  const PendingApprovalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0), // Margin for spacing
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: const Row(
        children: [
          Icon(Icons.hourglass_top_rounded, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Your dealer account is pending approval. You are currently seeing customer prices.",
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}