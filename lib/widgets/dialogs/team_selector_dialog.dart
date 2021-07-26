import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/widgets/icon_text_button.dart';
import 'package:backrec_flutter/widgets/team_selector_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

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

  late Team homeTeam, awayTeam;
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              //home and away team,
              Container(
                height: Get.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //home
                      TeamSelectorDropdown(
                        controller: homeController,
                        icon: FeatherIcons.home,
                        onSelected: (suggestion) {
                          print((suggestion as Team).name);
                          homeController.text = (suggestion).name;
                          homeTeam = suggestion;
                        },
                      ),
                      //vs
                      Text("VS",
                          style: Get.textTheme.bodyText1!
                              .copyWith(fontSize: 50, color: Colors.white)),
                      //away
                      TeamSelectorDropdown(
                        controller: awayController,
                        icon: FeatherIcons.compass,
                        onSelected: (suggestion) {
                          print((suggestion as Team).name);
                          awayController.text = (suggestion).name;
                          awayTeam = suggestion;
                        },
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
                              widget.onTeamsSelected(homeTeam, awayTeam);
                              print(
                                  "Teams: ${homeTeam.name} , ${awayTeam.name}");
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
      ],
    );
  }
}
