import "package:flutter/material.dart";

class DelayedDisplay extends StatefulWidget {
  const DelayedDisplay({
    required this.child,
    super.key,
    this.delay = const Duration(milliseconds: 300),
  });

  final Widget child;
  final Duration delay;

  @override
  State<DelayedDisplay> createState() => _DelayedDisplayState();
}

class _DelayedDisplayState extends State<DelayedDisplay> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      _isVisible ? widget.child : const SizedBox.shrink();
}
