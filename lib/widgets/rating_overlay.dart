import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

typedef DoubleCallback = Function(double);

class RatingOverlay extends StatelessWidget {
  final DoubleCallback onRatingUpdated;
  const RatingOverlay({
    Key? key,
    required this.onRatingUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTapCancel: () {
        print("tap cancelled!");
      },
      child: Container(
          width: width,
          height: height,
          color: GlobalColors.primaryGrey,
          child: Center(
              child: RatingBar.builder(
                  unratedColor: Colors.white,
                  glowColor: GlobalColors.primaryRed,
                  // initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                  updateOnDrag: true,
                  onRatingUpdate: onRatingUpdated))),
    );
  }
}
