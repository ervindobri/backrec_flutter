import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/timer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Display a blinking red ellipse and the elapsed time for the current recording session
///
/// [blinkColor] sets the color of the blinking ellipse (primaryColor by default)
///
/// [timePassed] updates the current value of the Text to be displayed
class RecordTime extends StatelessWidget {
  const RecordTime({
    Key? key,
    this.blinkColor = Colors.red,
    this.timePassed = Duration.zero,
  }) : super(key: key);

  final Color blinkColor;
  final Duration timePassed;

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 600) % 60).floor().toString().padLeft(2, '0');
    final secondsStr =
        ((duration / 10) % 60).floor().toString().padLeft(2, '0');
    // final milliSecondsStr =
    // (((duration * 10) % 99)).floor().toString().padLeft(0, '');
    final seconds = ((duration / 10) % 60).floor();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            BlocBuilder<TimerBloc, TimerState>(
              buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
              builder: (context, state) {
                if (state is TimerRunInProgress) {
                  final color = seconds % 2 == 1
                      ? GlobalColors.primaryRed
                      : Colors.transparent;
                  return Container(
                    width: 12,
                    height: 12,
                    margin: EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: color),
                  );
                }
                return SizedBox();
              },
            ),
            Text(
              '$minutesStr:$secondsStr'
              // ':$milliSecondsStr'
              ,
              style: context.bodyText1.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
