import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/core/extensions/string_ext.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/core/utils/nav_utils.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/playback/presentation/cubit/trimmer_cubit.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/blurry_icon_button.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/marker_tile.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_trimmer/video_trimmer.dart';

Future<void> openUploadDialog(BuildContext context, String videoPath) async {
  final trimmerCubit = sl<TrimmerCubit>();
  final markerCubit = sl<MarkerCubit>();
  final playbackBloc = sl<PlaybackBloc>();
  final directory = await getApplicationDocumentsDirectory();
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
        BlocProvider.value(
          value: playbackBloc,
        ),
      ],
      child: UploadDialog(
        directory: directory.path,
        videoPath: videoPath.parsed, //get video name out of path
      ),
    ),
  );
}

//TODO!: display clip thumbnail for each clip saved
class UploadDialog extends StatefulWidget {
  final String directory;
  final String videoPath;
  const UploadDialog(
      {Key? key, required this.videoPath, required this.directory})
      : super(key: key);

  @override
  State<UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  final List<Marker> selected = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final markers = context.select((MarkerCubit value) => value.markers);
    final playbackBloc = context.read<PlaybackBloc>();
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: GlobalStyles.radiusAll24,
          child: BackdropFilter(
            filter: GlobalStyles.blur,
            child: Container(
              color: GlobalColors.primaryGrey.withOpacity(.6),
              width: width,
              height: height,
              child: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(height: 50), //gridview with markers
                            SizedBox(
                              height: (markers.length / 4).ceil() * 200,
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                // scrollDirection: Axis.horizontal,
                                crossAxisCount: 4,
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                children: markers.map(
                                  (e) {
                                    final marker = e;
                                    final isSelected =
                                        selected.contains(marker);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20.0, bottom: 20),
                                      child: BlocProvider.value(
                                        value: playbackBloc
                                          ..add(InitializeThumbnailEvent(
                                              videoPath:
                                                  "${widget.directory}/${widget.videoPath.parsedPath}/${marker.id}.mp4")),
                                        child: MarkerTile(
                                            marker: marker,
                                            isSelected: isSelected,
                                            onTap: () {
                                              setState(() {
                                                if (isSelected) {
                                                  selected.remove(marker);
                                                } else {
                                                  selected.add(marker);
                                                }
                                              });
                                            }),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: width - 40,
                        margin: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlurryIconButton(
                                onPressed: () {
                                  NavUtils.back(context);
                                },
                                label: "Cancel",
                                icon: CupertinoIcons.clear),
                            BlurryIconButton(
                                onPressed: () {
                                  NavUtils.back(context);
                                },
                                color: GlobalColors.primaryRed,
                                label: "Upload",
                                icon: CupertinoIcons.cloud_upload),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        height: 32,
                        width: width,
                        color: GlobalColors.primaryGrey.withOpacity(.6),
                        child: Center(
                          child: Text(
                            "Clips - ${widget.videoPath.parsedPath}",
                            style: context.headline6.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
