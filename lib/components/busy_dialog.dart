import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ------------------------------ FUNCTIONS -----------------------------

Future<T> showBusyDialog<T>({
  @required BuildContext context,
  @required Future<T> Function() action,
}) async {
  final state = BusyOverlay.of(context);
  state.show();
  final result = await action();
  state.hide();
  return result;
}

// ------------------------------- CLASSES ------------------------------
class BusyOverlay extends StatefulWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const BusyOverlay({
    @required this.child,
    Key key,
  }) : super(key: key);

  // ------------------------------- FIELDS -------------------------------
  final Widget child;

  // ------------------------------- METHODS ------------------------------
  @override
  BusyOverlayState createState() => BusyOverlayState();

  // --------------------------- STATIC METHODS ---------------------------
  static BusyOverlayState of(BuildContext context) {
    final state = context.findRootAncestorStateOfType<BusyOverlayState>();
    if (state == null) {
      throw FlutterError('Wrap your root widget with the BusyOverlay.');
    }
    return state;
  }
}

class BusyOverlayState extends State<BusyOverlay>
    with SingleTickerProviderStateMixin {
  // ---------------------------- CONSTRUCTORS ----------------------------
  BusyOverlayState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
      reverseDuration: Duration(milliseconds: 150),
    );
    _controller.addListener(() => setState(() {}));
  }

  // ------------------------------- FIELDS -------------------------------
  AnimationController _controller;
  bool _isBusy = false;

  // ------------------------------- METHODS ------------------------------
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Positioned.fill(child: widget.child),
          if (_isBusy && !kIsWeb)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _controller.value * 10.0,
                  sigmaY: _controller.value * 10.0,
                ),
                child: Container(
                  color: Colors.black.withOpacity(_controller.value * 0.75),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          if (_isBusy && kIsWeb)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(_controller.value * 0.75),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void show() {
    _controller.reset();
    setState(() {
      _isBusy = true;
    });
    _controller.forward();
  }

  void hide() {
    void onCompleted(AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        _controller.removeStatusListener(onCompleted);
        setState(() {
          _isBusy = false;
        });
      }
    }
    _controller.addStatusListener(onCompleted);
    _controller.reverse();
  }
}