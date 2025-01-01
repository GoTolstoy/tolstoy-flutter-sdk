import "package:flutter/material.dart";

class DelayedDisplay extends StatefulWidget {
  const DelayedDisplay({
    required this.child,
    required this.isVisible,
    super.key,
    this.delay = const Duration(milliseconds: 300),
    this.transitionDuration = const Duration(milliseconds: 100),
  });

  final Widget child;
  final bool isVisible;
  final Duration delay;
  final Duration transitionDuration;

  @override
  State<DelayedDisplay> createState() => _DelayedDisplayState();
}

class _DelayedDisplayState extends State<DelayedDisplay> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _updateVisibility();
  }

  @override
  void didUpdateWidget(DelayedDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible != widget.isVisible) {
      _updateVisibility();
    }
  }

  void _updateVisibility() {
    if (widget.isVisible) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          setState(() {
            _isVisible = true;
          });
        }
      });
    } else {
      setState(() {
        _isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: widget.isVisible && _isVisible ? 1.0 : 0.0,
        duration: widget.transitionDuration,
        child: widget.child,
      );
}
