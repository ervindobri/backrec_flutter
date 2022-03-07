import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/widgets/triangle_shape.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MarkerPin extends StatelessWidget {
  const MarkerPin({
    Key? key,
    required this.marker,
    required this.totalDuration,
    required this.current,
    required this.totalWidth,
    required this.onMarkerTap,
  }) : super(key: key);

  final Marker marker;
  final Duration totalDuration;
  final bool current;
  final double totalWidth;
  final VoidCallback onMarkerTap;

  @override
  Widget build(BuildContext context) {
    final position =
        calculatePosition(marker.endPosition, totalDuration, totalWidth);
    // final width = MediaQuery.of(context).size.width;
    return Positioned(
      bottom: 0,
      left: position,
      child: IconButton(
        onPressed: onMarkerTap,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        padding: EdgeInsets.zero,
        icon: Container(
          width: 30,
          height: 60,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 5,
                child: AnimatedSwitcher(
                  duration: kThemeAnimationDuration,
                  child: current
                      ? CustomPaint(
                          size: Size(20, 20),
                          painter:
                              DrawTriangleShape(color: GlobalColors.primaryRed))
                      : CustomPaint(
                          size: Size(20, 20),
                          painter: DrawTriangleShape(
                              color: GlobalColors.secondaryRed)),
                ),
              ),
              Positioned(
                bottom: 10,
                child: AnimatedContainer(
                    width: 30,
                    height: 30,
                    duration: kThemeAnimationDuration,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: current
                            ? GlobalColors.primaryRed
                            : GlobalColors.secondaryRed),
                    child: Center(
                      child: FaIcon(FontAwesomeIcons.volleyballBall,
                          color: Colors.white, size: 15),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculatePosition(
      Duration endPosition, Duration totalDuration, double totalWidth) {
    final rate = (endPosition.inMicroseconds * totalWidth) /
        totalDuration.inMicroseconds;
    return rate - 16; // 17pixel offset
  }
}
