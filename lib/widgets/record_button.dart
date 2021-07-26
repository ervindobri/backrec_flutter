import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({
    Key? key,
    required bool recordingStarted,
    required this.onRecord,
  })  : _recordingStarted = recordingStarted,
        super(key: key);

  final bool _recordingStarted;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onRecord,
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (widget, animation) {
                return FadeTransition(
                  opacity: animation.drive(Tween(begin: 0.0, end: 1.0)),
                  child: widget,
                );
              },
              child: _recordingStarted
                  ? Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: GlobalColors.primaryRed),
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: GlobalColors.primaryRed),
                    ),
            ),
          ),
        ));
  }
}
