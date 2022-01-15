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
    required this.totalWidth,
    required this.onMarkerTap,
  }) : super(key: key);

  final Marker marker;
  final Duration totalDuration;
  final double totalWidth;
  final VoidCallback onMarkerTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: calculatePosition(marker.endPosition, totalDuration, totalWidth),
      child: InkWell(
        onTap: onMarkerTap,
        child: Container(
          width: 30,
          height: 60,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 5,
                child: CustomPaint(
                    size: Size(20, 20),
                    painter: DrawTriangleShape(color: GlobalColors.primaryRed)),
              ),
              Positioned(
                bottom: 10,
                child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: GlobalColors.primaryRed),
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
    var rate = ((endPosition.inMilliseconds / 1000) * totalWidth) /
        (totalDuration.inMilliseconds / 1000);
    return rate - 8; // 17pixel offset
  }
}
