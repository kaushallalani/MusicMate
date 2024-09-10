import 'package:flutter/material.dart';

enum AnimationType { slide, fade, scale }

class CustomAnimatedWidget extends StatefulWidget {
  final Widget child;
  final AnimationType animationType;
  final Duration animationDuration;
  final Duration displayDuration;

  const CustomAnimatedWidget({
    super.key,
    required this.child,
    required this.animationType,
    this.animationDuration = const Duration(milliseconds: 300),
    this.displayDuration = const Duration(seconds: 2),
  });

  @override
  _CustomAnimatedWidgetState createState() => _CustomAnimatedWidgetState();
}

class _CustomAnimatedWidgetState extends State<CustomAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Future.delayed(widget.displayDuration).then((_) {
      _controller.reverse().then((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.animationType) {
      case AnimationType.fade:
        return FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        );
      case AnimationType.slide:
        return SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        );
      case AnimationType.scale:
        return ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        );
      default:
        return widget.child;
    }
  }
}
