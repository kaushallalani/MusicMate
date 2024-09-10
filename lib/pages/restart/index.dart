import 'package:flutter/material.dart';

class Restart extends StatefulWidget {
  final Widget child;

  const Restart({Key? key, required this.child}) : super(key: key);

  static void restartApp(BuildContext context) {
    final _RestartState? state = context.findAncestorStateOfType<_RestartState>();
    state?.restartApp();
  }

  @override
  State<Restart> createState() => _RestartState();
}

class _RestartState extends State<Restart> {
  Key key = UniqueKey();

  void restartApp() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        key = UniqueKey();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
