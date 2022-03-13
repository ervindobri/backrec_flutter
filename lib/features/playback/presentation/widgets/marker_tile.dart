import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarkerTile extends StatefulWidget {
  final Marker marker;
  final VoidCallback onTap;
  const MarkerTile({
    Key? key,
    required this.marker,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MarkerTile> createState() => _MarkerTileState();
}

class _MarkerTileState extends State<MarkerTile> {
  bool isSelected = false;

  @override
  void initState() {
    print("init");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("changed dep.");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<PlaybackBloc, PlaybackState>(
      builder: (context, state) {
        Widget content = SizedBox();
        if (state is ThumbnailInitialized) {
          content = Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  fit: BoxFit.fitWidth, image: MemoryImage(state.thumbnail)),
              borderRadius: GlobalStyles.radius(16),
            ),
          );
        } else if (state is PlaybackInitializing) {
          //progress bar
          content = CircularProgressIndicator(color: Colors.white);
        } else {
          content = SizedBox();
        }
        return SizedBox(
          width: 100,
          height: 100,
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(24),
            strokeCap: StrokeCap.square,
            color: isSelected ? GlobalColors.primaryRed : Colors.white,
            strokeWidth: 5,
            dashPattern: isSelected ? [1] : [15, 14],
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
                    onTap: () {
                      setState(() => isSelected = !isSelected);
                      widget.onTap();
                    },
                    child: content),
              ),
            ),
          ),
        );
      },
    );
  }
}
