import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polaris/presentation/widgets/text_widget.dart';

class ElevatedButtonWidget extends StatefulWidget {
  final String? title;
  final FontWeight? fontWeight;
  final Function()? onPressed;
  final Widget Function(bool)? child;

  const ElevatedButtonWidget({
    super.key,
    this.title,
    this.fontWeight,
    this.onPressed,
    this.child,
  });

  @override
  State<ElevatedButtonWidget> createState() => _ElevatedButtonWidgetState();
}

class _ElevatedButtonWidgetState extends State<ElevatedButtonWidget> {
  StreamController<bool> streamState = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    streamState.sink.add(false);
  }

  @override
  void dispose() {
    super.dispose();
    streamState.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEvent event) {
        streamState.sink.add(true);
      },
      onExit: (PointerEvent event) {
        streamState.sink.add(false);
      },
      child: StreamBuilder(
        stream: streamState.stream,
        builder: (_, AsyncSnapshot<bool> snapshot) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                side: const BorderSide(
                  color: Colors.transparent,
                  width: 50,
                ),
              ),
            ),
            onPressed: widget.onPressed,
            child: Center(
              child: widget.child?.call(snapshot.data ?? false) ??
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: TextWidget(
                      text: widget.title,
                      color: Colors.white,
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }
}
