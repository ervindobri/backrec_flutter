import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/constants/global_styles.dart';
import 'package:flutter/material.dart';

class MarkerContainer extends StatelessWidget {
  final Widget content;
  const MarkerContainer({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: GlobalStyles.blur,
        child: Container(
          height: width / 3,
          width: width / 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: GlobalColors.primaryGrey.withOpacity(.6),
            border: Border.all(
              color: Colors.white.withOpacity(.6),
              width: 5,
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}
