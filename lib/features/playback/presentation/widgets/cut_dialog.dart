import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/trimmer_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void openCutDialog(BuildContext context) {
  final videoPath = context.read<PlaybackRepository>().path;
  final markers = context.read<MarkerCubit>().markers;
  showDialog(
    context: context,
    useSafeArea: false,
    builder: (context) => BlocProvider(
      create: (context) =>
          sl<TrimmerBloc>()..add(TrimVideo(video: videoPath, markers: markers)),
      child: CutDialog(),
    ),
  );
}

class CutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: GlobalStyles.radiusAll24,
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      backgroundColor: Colors.white,
                      color: GlobalColors.primaryRed,
                    ),
                  ),
                  Text("status",
                      style: context.bodyText1.copyWith(color: Colors.white)),
                  Spacer(),
                  TextButton(
                      style: GlobalStyles.buttonStyle(),
                      onPressed: () {},
                      child: Text("Select clips",
                          style:
                              context.bodyText1.copyWith(color: Colors.white)))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
