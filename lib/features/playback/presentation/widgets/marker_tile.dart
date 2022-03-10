import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<PlaybackBloc, PlaybackState>(
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is ThumbnailInitialized) {
          widget = Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  fit: BoxFit.fitWidth, image: MemoryImage(state.thumbnail)),
              borderRadius: GlobalStyles.radius(16),
            ),
          );
        } else if (state is PlaybackInitializing) {
          //progress bar
          widget = CircularProgressIndicator(color: Colors.white);
        } else {
          widget = SizedBox();
        }
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
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: GlobalStyles.radius(16),
                ),
                child: InkWell(
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: onTap,
                    child: widget),
              ),
            ),
          ),
        );
      },
    );
  }
}
