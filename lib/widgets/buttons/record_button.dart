import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return Container(
      width: 55,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: TextButton(
            onPressed: onRecord,
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)),
            child: Center(
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
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
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
              ),
            )),
      ),
    );
  }
}
