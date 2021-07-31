import 'dart:ui';

import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/constants/global_data.dart';
import 'package:backrec_flutter/models/filter.dart';
import 'package:backrec_flutter/models/marker.dart';
import 'package:backrec_flutter/models/player.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/widgets/buttons/icon_text_button.dart';
import 'package:backrec_flutter/widgets/filter_chip_color.dart';
import 'package:backrec_flutter/widgets/marker_container.dart';
import 'package:backrec_flutter/widgets/rating_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

typedef MarkerCallback = Function(Marker);

class MarkerDialog extends StatefulWidget {
  final Duration endPosition;
  final Team homeTeam, awayTeam;
  final MarkerCallback onMarkerConfigured;

  const MarkerDialog(
      {Key? key,
      required this.homeTeam,
      required this.awayTeam,
      required this.endPosition,
      required this.onMarkerConfigured})
      : super(key: key);
  @override
  State<MarkerDialog> createState() => _MarkerDialogState();
}

class _MarkerDialogState extends State<MarkerDialog> {
  Marker marker = new Marker();
  late final Team homeTeam, awayTeam;
  late List<Player> allPlayers;

  String _selectedName = '';

  //Selected markers
  Player player1 = new Player(), player2 = new Player();
  Team _selectedTeam = new Team();
  List selectedTypes = [];
  double _rating = 0.0;
  List<Filter> filters = [];
  @override
  void initState() {
    homeTeam = widget.homeTeam;
    awayTeam = widget.awayTeam;
    allPlayers = homeTeam.players + awayTeam.players;
    print("Init - ${homeTeam.name}, ${awayTeam.name} - ${widget.endPosition}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: GlobalColors.primaryGrey.withOpacity(.6),
          width: Get.width,
          height: Get.height,
        ),
        Container(
          width: Get.width,
          height: Get.height,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                //home and away team,
                Container(
                  height: Get.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text("Marker info",
                        //     style: Get.textTheme.bodyText1!
                        //         .copyWith(color: Colors.white)),
                        Container(
                          width: Get.width,
                          height: 220,
                          child: ListView(
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: [
                              //players
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: MarkerContainer(
                                  content: Container(
                                      child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: Get.height / 3,
                                          child: CupertinoPicker(
                                              diameterRatio: .85,
                                              itemExtent: 30,
                                              magnification: 1.5,
                                              onSelectedItemChanged: (index) {
                                                setState(() {
                                                  player1 = allPlayers
                                                      .where((element) =>
                                                          element != player2)
                                                      .toList()[index];
                                                });
                                              },
                                              children: allPlayers
                                                  .where((element) =>
                                                      element != player2)
                                                  .map((e) => Text(
                                                        e.firstName +
                                                            ' ' +
                                                            e.lastName,
                                                        style: Get.textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white),
                                                      ))
                                                  .toList()),
                                        ),
                                        Container(
                                          height: Get.height / 3,
                                          // height: 100,
                                          child: CupertinoPicker(
                                              diameterRatio: .85,
                                              itemExtent: 25,
                                              magnification: 1.5,
                                              onSelectedItemChanged: (index) {
                                                setState(() {
                                                  player2 = allPlayers
                                                      .where((element) =>
                                                          element != player1)
                                                      .toList()[index];
                                                });
                                              },
                                              children: allPlayers
                                                  .where((element) =>
                                                      element != player1)
                                                  .map((e) => Text(
                                                        e.firstName +
                                                            ' ' +
                                                            e.lastName,
                                                        style: Get.textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white),
                                                      ))
                                                  .toList()),
                                        ),
                                      ],
                                    ),
                                  )),
                                ),
                              ),
                              //teams
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: MarkerContainer(
                                    content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ChoiceChip(
                                        labelPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        onSelected: (bool) {
                                          setState(() {
                                            _selectedTeam = homeTeam;
                                          });
                                        },
                                        labelStyle: Get.textTheme.bodyText1!
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 25),
                                        selectedColor: GlobalColors.primaryRed,
                                        backgroundColor: GlobalColors
                                            .primaryGrey
                                            .withOpacity(.5),
                                        label: Text(homeTeam.name),
                                        selected: _selectedTeam == homeTeam),
                                    Text("VS",
                                        style: Get.textTheme.headline2!
                                            .copyWith(color: Colors.white)),
                                    ChoiceChip(
                                        labelPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        backgroundColor: GlobalColors
                                            .primaryGrey
                                            .withOpacity(.5),
                                        onSelected: (bool) {
                                          setState(() {
                                            _selectedTeam = awayTeam;
                                          });
                                        },
                                        label: Text(awayTeam.name),
                                        labelStyle: Get.textTheme.bodyText1!
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 25),
                                        selectedColor: GlobalColors.primaryRed,
                                        selected: _selectedTeam == awayTeam)
                                  ],
                                )),
                              ),
                              //marker type
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: MarkerContainer(
                                    content: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: GlobalData.markerTypes
                                          .map((e) => FilterChip(
                                              labelStyle: TextStyle(
                                                color: new FilterColor(),
                                              ),
                                              selectedColor:
                                                  GlobalColors.primaryRed,
                                              label: Text(e.toString()),
                                              selected:
                                                  selectedTypes.contains(e),
                                              onSelected: (selected) {
                                                setState(() {
                                                  if (selected) {
                                                    selectedTypes.add(e);
                                                  } else {
                                                    selectedTypes.remove(e);
                                                  }
                                                });
                                              }))
                                          .toList(),
                                    ),
                                  ),
                                )),
                              ),
                              //rating
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: MarkerContainer(
                                    content: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Get.dialog(RatingOverlay(
                                          onRatingUpdated: (rating) {
                                        setState(() {
                                          _rating = rating;
                                          Get.back();
                                        });
                                      }));
                                    },
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Icon(
                                              FeatherIcons.star,
                                              color: Colors.white,
                                              size: 170,
                                            ),
                                          ),
                                          if (_rating > 0)
                                            Center(
                                              child: Text(
                                                _rating.toStringAsFixed(0),
                                                style: Get.textTheme.bodyText1!
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 30),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                              )
                              //clip length
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //actions
                Positioned(
                    bottom: 10,
                    child: Container(
                      width: Get.width,
                      // color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconTextButton(
                              onPressed: () {
                                Get.back();
                              },
                              color: Colors.white.withOpacity(.4),
                              textColor: GlobalColors.primaryGrey,
                              icon: FeatherIcons.xCircle,
                              text: 'Cancel',
                            ),
                            IconTextButton(
                              onPressed: () {
                                setFilters();
                                widget.onMarkerConfigured(marker);
                                Get.back();
                              },
                              color: GlobalColors.primaryRed,
                              icon: FeatherIcons.checkCircle,
                              text: 'Apply',
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  void setFilters() {
    filters.add(PlayerFilter(player1, player2));
    marker.startPosition = widget.endPosition - GlobalData.clipLength;
    marker.endPosition = widget.endPosition;
    filters.add(TeamFilter(_selectedTeam));
    filters.add(new TypeFilter(selectedTypes
        .map((e) => MarkerType.values
            .firstWhere((type) => type.toString().split('.')[1] == e))
        .toList()));

    filters.add(new RatingFilter(_rating));
    marker.filters = filters;
    print("New marker created: $marker");
  }
}
