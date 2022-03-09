import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/constants/global_data.dart';
import 'package:backrec_flutter/core/constants/global_styles.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/core/utils/nav_utils.dart';
import 'package:backrec_flutter/core/utils/ui_utils.dart';
import 'package:backrec_flutter/features/record/data/models/team.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/team_selector_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

typedef TeamSelectionCallback = Function(Team, Team);

class TeamSelectorDialog extends StatefulWidget {
  final TeamSelectionCallback onTeamsSelected;

  const TeamSelectorDialog({
    Key? key,
    required this.onTeamsSelected,
  }) : super(key: key);

  @override
  State<TeamSelectorDialog> createState() => _TeamSelectorDialogState();
}

class _TeamSelectorDialogState extends State<TeamSelectorDialog> {
  final TextEditingController homeController = TextEditingController();
  final TextEditingController awayController = TextEditingController();
  late FocusNode focusNodeHome, focusNodeAway;
  Team? homeTeam, awayTeam;
  @override
  void initState() {
    focusNodeHome = FocusNode();
    focusNodeAway = FocusNode();
    focusNodeHome.unfocus();
    focusNodeAway.unfocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          color: GlobalColors.primaryGrey.withOpacity(.7),
          width: width,
          height: height,
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: GlobalStyles.blur,
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  //home and away team,
                  Container(
                    height: height,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //home
                          Column(
                            children: [
                              TeamSelectorDropdown(
                                controller: homeController,
                                focusNode: focusNodeHome,
                                icon: FeatherIcons.home,
                                onSelected: (suggestion) {
                                  print((suggestion as Team).name);
                                  homeController.text = (suggestion).name;
                                  homeTeam = suggestion;
                                },
                              ),
                              SizedBox(height: 12),
                              ...GlobalData.getTeams("")
                                  .map((e) => Container(
                                        width: width / 3,
                                        height: 40,
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: TextButton(
                                            onPressed: () {
                                              setState(() => homeTeam = e);
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: homeTeam == e
                                                  ? MaterialStateProperty.all(
                                                      Colors.white)
                                                  : MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius: GlobalStyles
                                                          .radiusAll12,
                                                      side: BorderSide(
                                                          color: GlobalColors
                                                              .primaryRed))),
                                            ),
                                            child: Text(e.name,
                                                style: context.bodyText1
                                                    .copyWith(
                                                        color: homeTeam == e
                                                            ? GlobalColors
                                                                .textColor
                                                            : Colors.white))),
                                      ))
                                  .toList()
                            ],
                          ),
                          //vs
                          Text("VS",
                              style: context.bodyText1
                                  .copyWith(fontSize: 50, color: Colors.white)),
                          //away
                          Column(
                            children: [
                              TeamSelectorDropdown(
                                controller: awayController,
                                icon: FeatherIcons.compass,
                                focusNode: focusNodeAway,
                                onSelected: (suggestion) {
                                  print((suggestion as Team).name);
                                  awayController.text = (suggestion).name;
                                  awayTeam = suggestion;
                                },
                              ),
                              SizedBox(height: 12),
                              ...GlobalData.getTeams("")
                                  .map((e) => Container(
                                        width: width / 3,
                                        height: 40,
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                awayTeam = e;
                                              });
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: awayTeam == e
                                                  ? MaterialStateProperty.all(
                                                      Colors.white)
                                                  : MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius: GlobalStyles
                                                          .radiusAll12,
                                                      side: BorderSide(
                                                          color: GlobalColors
                                                              .primaryRed))),
                                            ),
                                            child: Text(e.name,
                                                style: context.bodyText1
                                                    .copyWith(
                                                        fontSize: 12,
                                                        color: awayTeam == e
                                                            ? GlobalColors
                                                                .textColor
                                                            : Colors.white))),
                                      ))
                                  .toList()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //actions
                  Positioned(
                      bottom: 10,
                      child: Container(
                        width: width,
                        // color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  NavUtils.back(context);
                                },
                                style: GlobalStyles.buttonStyle(
                                    color: Colors.white),
                                icon: Icon(FeatherIcons.xCircle,
                                    color: GlobalColors.primaryGrey),
                                label: Text('Cancel', style: context.bodyText1),
                              ),
                              TextButton.icon(
                                style: GlobalStyles.buttonStyle(),
                                onPressed: () {
                                  if (homeTeam != null && awayTeam != null) {
                                    widget.onTeamsSelected(
                                        homeTeam!, awayTeam!);
                                    print(
                                        "Teams: ${homeTeam!.name} , ${awayTeam!.name}");
                                    NavUtils.back(context);
                                  } else {
                                    UiUtils.showToast("Select teams!");
                                  }
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
      ],
    );
  }
}
