import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/core/utils/nav_utils.dart';
import 'package:backrec_flutter/features/playback/presentation/cubit/trimmer_cubit.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/blurry_icon_button.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/clips_dialog.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';

void openCutDialog(
    BuildContext context, String videoPath, List<Marker> markers) {
  final trimmerCubit = sl<TrimmerCubit>();
  final markerCubit = sl<MarkerCubit>();
  showDialog(
    context: context,
    useSafeArea: false,
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: trimmerCubit,
        ),
        BlocProvider.value(
          value: markerCubit,
        ),
      ],
      child: CutDialog(
        path: videoPath,
      ),
    ),
  );
}

class CutDialog extends StatefulWidget {
  final String path;

  const CutDialog({Key? key, required this.path}) : super(key: key);

  @override
  State<CutDialog> createState() => _CutDialogState();
}

class _CutDialogState extends State<CutDialog> {
  double? _value = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final markers = context.select((MarkerCubit value) => value.markers);
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: GlobalStyles.radiusAll24,
          child: BackdropFilter(
            filter: GlobalStyles.blur,
            child: Container(
              color: GlobalColors.primaryGrey.withOpacity(.6),
              width: width / 2,
              height: height * .7,
              padding: const EdgeInsets.all(20),
              child: BlocConsumer<TrimmerCubit, TrimmerState>(
                listener: (context, state) {
                  if (state is TrimmerFinished) {
                    setState(() {
                      _value = 1.0;
                    });
                  }
                },
                builder: (context, state) {
                  String text = "";
                  if (state is TrimmerLoading) {
                  } else if (state is TrimmerVideoLoaded) {
                    text = "Video loaded";
                  } else if (state is TrimmerMarkersLoaded) {
                    text = "Markers loaded";
                  } else if (state is TrimmerTrimming) {
                    text = "Creating new clip";
                  } else if (state is TrimmerFinished) {
                    text = "Process finished!";
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(height: 40),
                      // ClipRRect(
                      //   borderRadius: GlobalStyles.radiusAll24,
                      //   child: LinearProgressIndicator(
                      //     minHeight: 10,
                      //     value: _value,
                      //     backgroundColor: Colors.white,
                      //     color: GlobalColors.primaryRed,
                      //   ),
                      // ),
                      // Text(text,
                      //     style:
                      //         context.bodyText1.copyWith(color: Colors.white)),
                      // Spacer(),
                      if (state is TrimmerFinished) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text("Clips saved to application directory!",
                              textAlign: TextAlign.center,
                              style: context.bodyText2
                                  .copyWith(color: Colors.white)),
                        ),
                        BlurryIconButton(
                          color: GlobalColors.primaryRed,
                          onPressed: () {
                            NavUtils.back(context);
                            openUploadDialog(context, widget.path);
                          },
                          icon: CupertinoIcons.videocam,
                          label: "Select clips",
                        )
                      ] else if (state is TrimmerTrimming) ...[
                        Expanded(
                          child: SizedBox(
                            // height: 50,
                            // width: 50,
                            child: RiveAnimation.asset(
                              'assets/anims/run-v7.riv',
                              onInit: (artboard) {},
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(state.message,
                              textAlign: TextAlign.center,
                              style: context.bodyText2
                                  .copyWith(color: Colors.white)),
                        ),
                      ] else ...[
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                              "The video will be cut into small clips according to the markers.",
                              textAlign: TextAlign.center,
                              style: context.bodyText2
                                  .copyWith(color: Colors.white)),
                        ),
                        TextButton(
                            style: GlobalStyles.buttonStyle(),
                            onPressed: () {
                              context.read<TrimmerCubit>().trimVideo(
                                  video: widget.path, markers: markers);
                              setState(() => _value = null);
                            },
                            child: Text("Trim Video",
                                style: context.bodyText1
                                    .copyWith(color: Colors.white)))
                      ]
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
