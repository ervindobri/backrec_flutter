import 'package:backrec_flutter/core/constants/constants.dart';
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
    return IconButton(
      iconSize: 56,
      onPressed: onRecord,
      padding: EdgeInsets.zero,
      icon: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
            border: GlobalStyles.whiteBorder(), shape: BoxShape.circle),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: AnimatedContainer(
              width: _recordingStarted ? 32 : 50,
              height: _recordingStarted ? 32 : 50,
              duration: kThemeAnimationDuration,
              curve: Curves.easeInBack,
              decoration: BoxDecoration(
                  borderRadius: _recordingStarted
                      ? BorderRadius.circular(8)
                      : BorderRadius.circular(50),
                  color: GlobalColors.primaryRed),
            ),
          ),
        ),
      ),
    );
  }
}
