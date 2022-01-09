import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/timer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            BlocBuilder<TimerBloc, TimerState>(
              builder: (context, state) {
                if (state is TimerRunInProgress) {
                  final color = state.duration % 2 == 1
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
            BlocBuilder<TimerBloc, TimerState>(
              builder: (context, state) {
                return Text(
                  '$minutesStr:$secondsStr',
                  style: context.bodyText1.copyWith(color: Colors.white),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  String formatTime(int duration) {
    final minutes = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final seconds = (duration % 60).floor().toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
