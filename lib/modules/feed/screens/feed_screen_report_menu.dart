import 'package:flutter/material.dart';

class FeedScreenReportMenu extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onReport;

  const FeedScreenReportMenu({
    super.key,
    required this.onCancel,
    required this.onReport,
  });

  @override
  State<FeedScreenReportMenu> createState() => _FeedScreenReportMenuState();
}

class _FeedScreenReportMenuState extends State<FeedScreenReportMenu> {
  static const _padding = EdgeInsets.fromLTRB(20, 30, 20, 40);

  String? _selectedReason;

  static final _lang = Map.unmodifiable({
    'title': 'Why are you reporting this content?',
    'cancel': 'Cancel',
    'report': 'Report',
  });

  static final _reportReasons = const [
    {
      'title': "It's bullying or harassment",
      'subtitle': 'It attacks an individual or a group of people.',
    },
    {
      'title': "It's a conflict of interest",
      'subtitle':
          "It's from someone affiliated with the Shop Store or a competitor's store.",
    },
    {
      'title': "It's a copyright issue",
      'subtitle': 'It violates or infringes a copyright',
    },
    {
      'title': "It's offensive",
      'subtitle':
          'It contains inappropriate, sexually explicit, or violent content.',
    },
    {
      'title': "It's fraud or scam",
      'subtitle': 'It has allegations about improper store or buyer behavior.',
    },
    {
      'title': "It's hate speech",
      'subtitle':
          'It contains harmful content based on an individual or group identity.',
    },
    {
      'title': 'It\'s about illegal activities or regulated goods',
      'subtitle':
          'It references items that go against Shop Merchant Guidelines.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQueryData.fromView(View.of(context)).padding;

    return Container(
      padding: _padding.copyWith(top: _padding.top + safeArea.top),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _lang['title'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _reportReasons.length,
              itemBuilder: (context, index) {
                final reason = _reportReasons[index];

                return RadioListTile(
                  title: Text(
                    reason['title']!,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    reason['subtitle']!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  value: reason['title'],
                  groupValue: _selectedReason,
                  onChanged: (value) => setState(() => _selectedReason = value),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: widget.onCancel,
                  child: Text(_lang['cancel']),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedReason != null ? widget.onReport : null,
                  child: Text(_lang['report']),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
