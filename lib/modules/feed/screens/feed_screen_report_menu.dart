import "package:flutter/material.dart";

// ignore: camel_case_types
class _lang {
  static const title = "Why are you reporting this content?";
  static const cancel = "Cancel";
  static const report = "Report";
}

class _ReportReason {
  const _ReportReason({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  final String id;
  final String title;
  final String subtitle;
}

class FeedScreenReportMenu extends StatefulWidget {
  const FeedScreenReportMenu({
    required this.onCancel,
    required this.onReport,
    super.key,
  });

  final VoidCallback onCancel;
  final Future<bool> Function({required String id, required String title})
      onReport;

  @override
  State<FeedScreenReportMenu> createState() => _FeedScreenReportMenuState();
}

class _FeedScreenReportMenuState extends State<FeedScreenReportMenu> {
  String? _selectedId;
  String? _selectedTitle;
  bool _isSubmitting = false;

  static const _reportReasons = [
    _ReportReason(
      id: "bullyingHarrassment",
      title: "It's bullying or harassment",
      subtitle: "It attacks an individual or a group of people.",
    ),
    _ReportReason(
      id: "conflictOfInterest",
      title: "It's a conflict of interest",
      subtitle:
          "It's from someone affiliated with the brand or a competitor's brand.",
    ),
    _ReportReason(
      id: "copyright",
      title: "It's a copyright issue",
      subtitle: "It violates or infringes a copyright",
    ),
    _ReportReason(
      id: "offensive",
      title: "It's offensive",
      subtitle:
          "It contains inappropriate, sexually explicit, or violent content.",
    ),
    _ReportReason(
      id: "fraudOrScam",
      title: "It's fraud or scam",
      subtitle: "It has allegations about improper store or buyer behavior.",
    ),
    _ReportReason(
      id: "hateSpeech",
      title: "It's hate speech",
      subtitle:
          "It contains harmful content based on an individual or group identity.",
    ),
    _ReportReason(
      id: "illegalActivities",
      title: "It's about illegal activities or regulated goods",
      subtitle: "It references items that go against guidelines.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final localSelectedId = _selectedId;
    final localSelectedTitle = _selectedTitle;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          _lang.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: _reportReasons
                  .map(
                    (reason) => RadioListTile<String?>(
                      title: Text(
                        reason.title,
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        reason.subtitle,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      value: reason.id,
                      groupValue: _selectedId,
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: EdgeInsets.zero,
                      onChanged: _isSubmitting
                          ? null
                          : (value) => setState(() {
                                _selectedId = reason.id;
                                _selectedTitle = reason.title;
                              }),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _isSubmitting ? null : widget.onCancel,
                child: const Text(_lang.cancel),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSubmitting ||
                        localSelectedId == null ||
                        localSelectedTitle == null
                    ? null
                    : () async {
                        setState(() => _isSubmitting = true);
                        try {
                          await widget.onReport(
                            id: localSelectedId,
                            title: localSelectedTitle,
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
                    : const Text(_lang.report),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
