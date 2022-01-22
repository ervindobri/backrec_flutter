import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/features/record/data/models/filter.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/features/record/data/models/team.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/dialogs/marker_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class MarkerInfo extends StatelessWidget {
  final Marker? marker;
  final Team? homeTeam, awayTeam;
  final bool visible;
  final MarkerCallback onMarkerConfigured;
  final VoidCallback onDelete;

  const MarkerInfo(
      {Key? key,
      required this.marker,
      this.visible = true,
      this.homeTeam,
      this.awayTeam,
      required this.onMarkerConfigured,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible && marker != null ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) => MarkerDialog(
                    endPosition: marker!.endPosition,
                    homeTeam: homeTeam,
                    awayTeam: awayTeam,
                    marker: marker!,
                    onMarkerConfigured: onMarkerConfigured,
                    onCancel: () {},
                    onDelete: onDelete,
                  ));
        },
        child: SizedBox(
          // height: 50,
          child: ClipRRect(
            child: BackdropFilter(
                filter: GlobalStyles.blur,
                child: Container(
                  // height: 50,
                  decoration: BoxDecoration(
                    borderRadius: GlobalStyles.radiusAll12,
                    color: GlobalColors.primaryGrey.withOpacity(.4),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  child: Wrap(
                    spacing: 12,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(FeatherIcons.info, color: Colors.white),
                      ...marker!.filters.map((e) {
                        switch (e.runtimeType) {
                          case PlayerFilter:
                            final playerFilter = e as PlayerFilter;
                            return Column(
                              children: [
                                Text(playerFilter.player1!.name,
                                    style: context.bodyText1),
                                Text(playerFilter.player2!.name,
                                    style: context.bodyText1),
                              ],
                            );
                          case TeamFilter:
                            final teamFilter = e as TeamFilter;
                            return Text(teamFilter.team.name,
                                style: context.bodyText1);
                          case TypeFilter:
                            final typeFilter = e as TypeFilter;
                            return Wrap(
                              spacing: 4,
                              direction: Axis.vertical,
                              children: typeFilter.types
                                  .map((e) => Text("#${e.parse}",
                                      style: context.bodyText1
                                          .copyWith(color: Colors.white)))
                                  .toList(),
                            );
                          case RatingFilter:
                            final ratingFilter = e as RatingFilter;
                            return SizedBox(
                              width: 60,
                              height: 60,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(CupertinoIcons.star_fill,
                                      size: 36, color: Colors.white),
                                  Text(ratingFilter.rating.floor().toString()),
                                ],
                              ),
                            );
                          default:
                            return SizedBox();
                        }
                      }).toList()
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
