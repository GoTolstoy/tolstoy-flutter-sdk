import 'package:flutter/material.dart';

class FeedScreenReportMenu extends StatefulWidget {
  final VoidCallback onCancel;
  final Future<void> Function({required String id, required String title})
      onReport;

  const FeedScreenReportMenu({
    super.key,
    required this.onCancel,
    required this.onReport,
  });

  @override
  State<FeedScreenReportMenu> createState() => _FeedScreenReportMenuState();
}

class _FeedScreenReportMenuState extends State<FeedScreenReportMenu> {
  String? _selectedId;
  String? _selectedTitle;
  bool _isSubmitting = false;

  static final _lang = Map.unmodifiable({
    'title': 'Why are you reporting this content?',
    'cancel': 'Cancel',
    'report': 'Report',
  });

  static final _reportReasons = const [
    {
      'id': 'bullyingHarrassment',
      'title': "It's bullying or harassment",
      'subtitle': 'It attacks an individual or a group of people.',
    },
    {
      'id': 'conflictOfInterest',
      'title': "It's a conflict of interest",
      'subtitle':
          "It's from someone affiliated with the Shop Store or a competitor's store.",
    },
    {
      'id': 'copyright',
      'title': "It's a copyright issue",
      'subtitle': 'It violates or infringes a copyright',
    },
    {
      'id': 'offensive',
      'title': "It's offensive",
      'subtitle':
          'It contains inappropriate, sexually explicit, or violent content.',
    },
    {
      'id': 'fraudOrScam',
      'title': "It's fraud or scam",
      'subtitle': 'It has allegations about improper store or buyer behavior.',
    },
    {
      'id': 'hateSpeech',
      'title': "It's hate speech",
      'subtitle':
          'It contains harmful content based on an individual or group identity.',
    },
    {
      'id': 'illegalActivities',
      'title': 'It\'s about illegal activities or regulated goods',
      'subtitle':
          'It references items that go against Shop Merchant Guidelines.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _lang['title'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: _reportReasons.map(
                (reason) {
                  return RadioListTile<String?>(
                    title: Text(
                      reason['title']!,
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      reason['subtitle']!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    value: reason['id'],
                    groupValue: _selectedId,
                    onChanged: _isSubmitting
                        ? null
                        : (value) => setState(() {
                              _selectedId = reason['id'];
                              _selectedTitle = reason['title'];
                            }),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _isSubmitting ? null : widget.onCancel,
                child: Text(_lang['cancel']),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _selectedId == null || _isSubmitting
                    ? null
                    : () async {
                        setState(() => _isSubmitting = true);
                        try {
                          await widget.onReport(
                            id: _selectedId!,
                            title: _selectedTitle!,
                          );
                        } finally {
                          if (mounted) {
                            setState(() => _isSubmitting = false);
                          }
                        }
                      },
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_lang['report']),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
