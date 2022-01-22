import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/cut_dialog.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class OverlayActions extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback? setFocus;
  final bool inFocus;
  final bool isPlaying;
  final bool finishedPlaying;
  const OverlayActions(
      {Key? key,
      required this.onPressed,
      this.setFocus,
      required this.inFocus,
      required this.isPlaying,
      this.finishedPlaying = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final markers = context.select((MarkerCubit cubit) => cubit.markers);

    return Align(
      alignment: Alignment.center,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: inFocus ? 0.0 : 1,
        child: InkWell(
          onTap: setFocus,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          highlightColor: Colors.transparent,
          child: Container(
            width: width,
            height: height,
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!finishedPlaying)
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: IconButton(
                      iconSize: 100,
                      icon: Icon(
                        !isPlaying
                            ? CupertinoIcons.play_arrow_solid
                            : CupertinoIcons.pause_fill,
                        color: Colors.white.withOpacity(.3),
                      ),
                      onPressed: () {
                        if (!inFocus) {
                          onPressed();
                        }
                      },
                    ),
                  ),
                AnimatedOpacity(
                  opacity: finishedPlaying ? 1.0 : 0.0,
                  duration: kThemeAnimationDuration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        label: Text(""),
                        style: GlobalStyles.buttonStyle(
                            color: GlobalColors.primaryGrey.withOpacity(.6)),
                        icon: Icon(
                          CupertinoIcons.refresh,
                          size: 100,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (!inFocus) {
                            onPressed();
                          }
                        },
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      ValueListenableBuilder<List<Marker>>(
                          valueListenable: ValueNotifier(markers),
                          builder: (context, value, child) {
                            if (value.isEmpty) {
                              return SizedBox();
                            } else {
                              return TextButton.icon(
                                label: Text("Cut",
                                    style: context.headline1
                                        .copyWith(color: Colors.white)),
                                style: GlobalStyles.buttonStyle(
                                    color: GlobalColors.primaryGrey
                                        .withOpacity(.6)),
                                icon: Icon(
                                  CupertinoIcons.scissors_alt,
                                  size: 44,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (!inFocus && finishedPlaying) {
                                    //open cut dialog
                                    openCutDialog(context);
                                  }
                                },
                              );
                            }
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
