import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class MarkerTile extends StatelessWidget {
  final Marker marker;
  final bool isSelected;
  final VoidCallback onTap;
  const MarkerTile({
    Key? key,
    required this.marker,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 100,
      height: 100,
      child: DottedBorder(
        borderType: isSelected ? BorderType.RRect : BorderType.RRect,
        radius: Radius.circular(24),
        strokeCap: StrokeCap.square,
        color: isSelected ? GlobalColors.primaryRed : Colors.white,
        strokeWidth: 5,
        dashPattern: [1],
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: GlobalStyles.radiusAll24,
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: GlobalStyles.radiusAll24,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: GlobalColors.lightGrey.withOpacity(.4),
                  borderRadius: GlobalStyles.radiusAll24,
                ),
                child: Center(
                  child: Text(
                    marker.id.toString(),
                    style: context.headline4.copyWith(
                      color:
                          isSelected ? GlobalColors.primaryRed : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}