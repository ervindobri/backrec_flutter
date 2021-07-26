import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordTime extends StatelessWidget {
  const RecordTime({
    Key? key,
    required this.blinkColor,
    required this.timePassed,
  }) : super(key: key);

  final Color blinkColor;
  final String timePassed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: blinkColor),
            ),
            Text(
              timePassed,
              style: Get.textTheme.bodyText1!.copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
