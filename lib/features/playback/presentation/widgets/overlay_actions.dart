import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverlayActions extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback? setFocus;
  final bool inFocus;
  final bool isPlaying;
  const OverlayActions(
      {Key? key,
      required this.onPressed,
      this.setFocus,
      required this.inFocus,
      required this.isPlaying})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.center,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: inFocus ? 0.0 : 1,
        child: InkWell(
          onTap: setFocus,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          highlightColor: Colors.transparent,
          child: Visibility(
            visible: !inFocus,
            child: Container(
              width: width,
              height: height,
              color: Colors.transparent,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: IconButton(
                  iconSize: 100,
                  icon: Icon(
                    !isPlaying
                        ? CupertinoIcons.play_arrow_solid
                        : CupertinoIcons.pause_fill,
                    color: Colors.white.withOpacity(.3),
                  ),
                  onPressed: onPressed,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
