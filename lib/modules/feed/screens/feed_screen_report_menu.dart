import 'package:flutter/material.dart';

class FeedScreenReportMenu extends StatelessWidget {
  static const padding = EdgeInsets.fromLTRB(20, 30, 20, 40);
  static final lang = Map.unmodifiable({});

  final VoidCallback onCancel;
  final VoidCallback onReport;

  const FeedScreenReportMenu({
    super.key,
    required this.onCancel,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Report Content',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 120),
          TextButton(
            onPressed: onCancel,
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
