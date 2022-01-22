import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/core/utils/nav_utils.dart';
import 'package:backrec_flutter/features/record/data/models/filter.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/features/record/data/models/player.dart';
import 'package:backrec_flutter/features/record/data/models/team.dart';
import 'package:backrec_flutter/widgets/filter_chip_color.dart';
import 'package:backrec_flutter/widgets/marker_container.dart';
import 'package:backrec_flutter/widgets/rating_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

typedef MarkerCallback = Function(Marker);

class MarkerDialog extends StatefulWidget {
  final Duration endPosition;
  final Marker? marker;
  final Team? homeTeam, awayTeam;
  final MarkerCallback onMarkerConfigured;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  const MarkerDialog(
      {Key? key,
      required this.homeTeam,
      required this.awayTeam,
      required this.endPosition,
      required this.onCancel,
      required this.onDelete,
      required this.onMarkerConfigured,
      this.marker})
      : super(key: key);
  @override
  State<MarkerDialog> createState() => _MarkerDialogState();
}

class _MarkerDialogState extends State<MarkerDialog> {
  Marker marker = Marker();
  late final Team homeTeam, awayTeam;
  late List<Player> allPlayers;
  // String _selectedName = '';
  //Selected markers
  Player? player1, player2;
  Team? _selectedTeam;
  List<MarkerType>? selectedTypes = [];
  double? _rating = 0.0;
  List<Filter> filters = [];

  List<Player> _selectedPlayers = [];
  @override
  void initState() {
    homeTeam = widget.homeTeam ?? Team();
    awayTeam = widget.awayTeam ?? Team();
    setInitialFilters();
    allPlayers = homeTeam.players + awayTeam.players;
    print("Init - ${homeTeam.name}, ${awayTeam.name} - ${widget.endPosition}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxWidth;
      final notchPadding = MediaQuery.of(context).viewPadding;
      print(notchPadding);
      return Stack(
        children: [
          Container(
            color: GlobalColors.primaryGrey.withOpacity(.6),
            width: width,
            height: height,
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: GlobalStyles.blur,
              child: Container(
                width: width,
                height: height,
                child: Material(
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      //home and away team,
                      Container(
                        height: height,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text("Marker info",
                              //     style: context.bodyText1!
                              //         .copyWith(color: Colors.white)),
                              Container(
                                width: width,
                                height: 220,
                                child: ListView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    //players
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: MarkerContainer(
                                        content: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                              width: 200,
                                              height: 200,
                                              child: ListView.builder(
                                                  itemCount: allPlayers.length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder: (_, index) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 3.0),
                                                      child: Container(
                                                        width: width,
                                                        color: (_selectedPlayers
                                                                .contains(
                                                                    allPlayers[
                                                                        index]))
                                                            ? GlobalColors
                                                                .primaryRed
                                                            : GlobalColors
                                                                .primaryGrey,
                                                        padding:
                                                            EdgeInsets.all(1.0),
                                                        child: ListTile(
                                                          onTap: () {
                                                            if (_selectedPlayers
                                                                .contains(
                                                                    allPlayers[
                                                                        index])) {
                                                              print(
                                                                  "Contains player!");
                                                              setState(() {
                                                                _selectedPlayers
                                                                    .remove(allPlayers[
                                                                        index]);
                                                              });
                                                            } else {
                                                              if (_selectedPlayers
                                                                      .length <
                                                                  2) {
                                                                print(
                                                                    "Adding player!");
                                                                setState(() {
                                                                  _selectedPlayers.add(
                                                                      allPlayers[
                                                                          index]);
                                                                });
                                                              }
                                                            }
                                                          },
                                                          title: Text(
                                                              allPlayers[index]
                                                                      .firstName +
                                                                  " " +
                                                                  allPlayers[
                                                                          index]
                                                                      .lastName,
                                                              style: context
                                                                  .bodyText1
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white)),
                                                        ),
                                                      ),
                                                    );
                                                  })),
                                        ),
                                      ),
                                    ),
                                    //teams
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10),
                                      child: MarkerContainer(
                                          content: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ChoiceChip(
                                              labelPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              onSelected: (bool) {
                                                setState(() {
                                                  _selectedTeam = homeTeam;
                                                });
                                              },
                                              labelStyle: context.bodyText1
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                              selectedColor:
                                                  GlobalColors.primaryRed,
                                              backgroundColor: GlobalColors
                                                  .primaryGrey
                                                  .withOpacity(.5),
                                              label: Text(homeTeam.name),
                                              selected:
                                                  _selectedTeam == homeTeam),
                                          Text("VS",
                                              style: context.headline2.copyWith(
                                                  color: Colors.white)),
                                          ChoiceChip(
                                              labelPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              backgroundColor: GlobalColors
                                                  .primaryGrey
                                                  .withOpacity(.5),
                                              onSelected: (bool) {
                                                setState(() {
                                                  _selectedTeam = awayTeam;
                                                });
                                              },
                                              label: Text(awayTeam.name),
                                              labelStyle: context.bodyText1
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                              selectedColor:
                                                  GlobalColors.primaryRed,
                                              selected:
                                                  _selectedTeam == awayTeam)
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
                                                      color: FilterColor(),
                                                    ),
                                                    selectedColor:
                                                        GlobalColors.primaryRed,
                                                    label: Text(e.parse),
                                                    selected: selectedTypes
                                                            ?.contains(e) ??
                                                        false,
                                                    onSelected: (selected) {
                                                      setState(() {
                                                        if (selected) {
                                                          selectedTypes?.add(e);
                                                        } else {
                                                          selectedTypes
                                                              ?.remove(e);
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
                                            showDialog(
                                                context: context,
                                                builder: (_) => RatingOverlay(
                                                        onRatingUpdated:
                                                            (rating) {
                                                      setState(() {
                                                        _rating = rating;
                                                        NavUtils.back(context);
                                                      });
                                                    }));
                                          },
                                          child: Center(
                                            child: Stack(
                                              children: [
                                                if (_rating != null) ...[
                                                  Center(
                                                    child: Icon(
                                                      FeatherIcons.star,
                                                      color: _rating! > 0
                                                          ? GlobalColors
                                                              .primaryRed
                                                          : Colors.white,
                                                      size: 170,
                                                    ),
                                                  ),
                                                  if (_rating! > 0)
                                                    Center(
                                                      child: Text(
                                                        _rating!
                                                            .toStringAsFixed(0),
                                                        style: context.bodyText1
                                                            .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 30),
                                                      ),
                                                    ),
                                                ]
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
                          bottom: 20,
                          left: notchPadding.left,
                          right: notchPadding.right,
                          child: Container(
                            width: width,
                            // color: Colors.black,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  TextButton.icon(
                                    style: GlobalStyles.buttonStyle(
                                        color: GlobalColors.lightGrey),
                                    onPressed: () {
                                      NavUtils.back(context);
                                      widget.onCancel();
                                    },
                                    icon: Icon(FeatherIcons.xCircle,
                                        color: GlobalColors.primaryGrey),
                                    label: Text('Cancel',
                                        style: context.bodyText1),
                                  ),
                                  SizedBox(width: 16),
                                  TextButton.icon(
                                    style: GlobalStyles.buttonStyle(
                                        color: Colors.transparent),
                                    onPressed: () {
                                      NavUtils.back(context);
                                      widget.onDelete();
                                    },
                                    icon: Icon(FeatherIcons.delete,
                                        color: GlobalColors.primaryRed),
                                    label: Text('Delete',
                                        style: context.bodyText1.copyWith(
                                            color: GlobalColors.primaryRed)),
                                  ),
                                  Spacer(),
                                  TextButton.icon(
                                    style: GlobalStyles.buttonStyle(
                                        color: GlobalColors.primaryRed),
                                    onPressed: () {
                                      setFilters();
                                      if (widget.marker != null &&
                                          widget.marker!.id != null) {
                                        marker.id = widget.marker!.id;
                                      } else {
                                        marker.id = DateTime.now()
                                            .millisecondsSinceEpoch;
                                      }
                                      widget.onMarkerConfigured(marker);
                                      NavUtils.back(context);
                                    },
                                    icon: Icon(FeatherIcons.checkCircle,
                                        color: Colors.white),
                                    label: Text('Apply',
                                        style: context.bodyText1
                                            .copyWith(color: Colors.white)),
                                  )
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void setFilters() {
    /// Set start and end position
    ///
    marker.startPosition = Duration.zero;
    if (widget.endPosition.compareTo(GlobalData.clipLength) > 0) {
      marker.startPosition = widget.endPosition - GlobalData.clipLength;
    }
    if (widget.marker != null) {
      marker.startPosition = widget.marker!.startPosition;
    }
    marker.endPosition = widget.endPosition;

    if (player1 != null || player2 != null) {
      filters.add(PlayerFilter(player1, player2));
    }

    if (_selectedTeam != null) {
      filters.add(TeamFilter(_selectedTeam!));
    }
    if (selectedTypes != null && selectedTypes!.isNotEmpty) {
      filters.add(TypeFilter(selectedTypes!
          .map((e) => MarkerType.values.firstWhere((type) => type == e))
          .toList()));
    }

    if (_rating != null && _rating != 0.0) {
      filters.add(new RatingFilter(_rating!));
    }
    marker.filters = filters;
    print("New marker created: $marker");
  }

  void setInitialFilters() {
    if (widget.marker != null) {
      final filters = widget.marker!.filters;
      for (var filter in filters) {
        switch (filter.runtimeType) {
          case PlayerFilter:
            _selectedPlayers = [
              (filter as PlayerFilter).player1!,
              (filter).player2!
            ];
            break;
          case TeamFilter:
            _selectedTeam = (filter as TeamFilter).team;
            break;
          case TypeFilter:
            selectedTypes = [...(filter as TypeFilter).types];
            break;
          case RatingFilter:
            _rating = (filter as RatingFilter).rating;
            break;
          default:
        }
      }
      print(selectedTypes);
    }
  }
}
