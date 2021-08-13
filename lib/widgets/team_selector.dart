import 'dart:ui';

import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/widgets/dialogs/team_selector_dialog.dart';
import 'package:backrec_flutter/widgets/buttons/icon_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

class TeamSelector extends StatefulWidget {
  final TeamSelectionCallback setTeams;
  final Team? initialHome, initialAway;
  const TeamSelector(
      {Key? key, required this.setTeams, this.initialHome, this.initialAway})
      : super(key: key);

  @override
  State<TeamSelector> createState() => _TeamSelectorState();
}

class _TeamSelectorState extends State<TeamSelector> {
  bool _teamSelected = false;

  //TODO: display team names
  Team homeTeam = Team(name: '', founded: 0000),
      awayTeam = Team(name: '', founded: 0000);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.dialog(TeamSelectorDialog(onTeamsSelected: (team1, team2) {
          setState(() {
            homeTeam = team1;
            awayTeam = team2;
          });
          widget.setTeams(homeTeam, awayTeam);
        }), barrierDismissible: false, useSafeArea: false);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: GlobalColors.primaryGrey.withOpacity(.4)),
            child: getTeams(),
          ),
        ),
      ),
    );
  }

  getTeams() {
    if (homeTeam.name == '' || awayTeam.name == '') {
      if (widget.initialHome!.name != '' && widget.initialAway!.name != '') {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(widget.initialHome!.name,
                  style: Get.textTheme.bodyText1!.copyWith(
                    color: Colors.white,
                  )),
              Text("VS",
                  style:
                      Get.textTheme.bodyText2!.copyWith(color: Colors.white)),
              Text(widget.initialAway!.name,
                  style: Get.textTheme.bodyText1!.copyWith(
                    color: Colors.white,
                  )),
            ],
          ),
        );
      } else {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(FeatherIcons.plusCircle, color: Colors.white),
              Text("Home team",
                  style: Get.textTheme.bodyText1!.copyWith(
                    color: Colors.white,
                  )),
              Text("VS",
                  style:
                      Get.textTheme.bodyText2!.copyWith(color: Colors.white)),
              Text("Away team",
                  style: Get.textTheme.bodyText1!.copyWith(
                    color: Colors.white,
                  )),
            ],
          ),
        );
      }
    } else {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (homeTeam.name == '' || awayTeam.name == '')
              Icon(FeatherIcons.plusCircle, color: Colors.white),
            Text(homeTeam.name == '' ? "Home team" : homeTeam.name,
                style: Get.textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                )),
            Text("VS",
                style: Get.textTheme.bodyText2!.copyWith(color: Colors.white)),
            Text(awayTeam.name == '' ? "Away team" : awayTeam.name,
                style: Get.textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                )),
          ],
        ),
      );
    }
  }
}
