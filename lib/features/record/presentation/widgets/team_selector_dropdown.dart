import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/constants/global_data.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

typedef ObjectCallback = Function(Object?);

class TeamSelectorDropdown extends StatelessWidget {
  final ObjectCallback onSelected;

  const TeamSelectorDropdown({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.icon,
    required this.onSelected,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 3,
      height: 50,
      decoration: BoxDecoration(
          color: GlobalColors.lightGrey,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FaIcon(icon, color: Colors.white, size: 20),
          ),
          Container(
            width: Get.width / 4.2,
            height: 40,
            margin: const EdgeInsets.only(left: 3.0, bottom: 5.0, right: 5.0),
            child: Material(
              color: GlobalColors.lightGrey,
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    controller: controller,
                    focusNode: focusNode,
                    cursorColor: Colors.white,
                    style: context.bodyText1.copyWith(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        fillColor: Colors.white,
                        focusColor: Colors.white)),
                suggestionsCallback: (pattern) async {
                  return GlobalData.getTeams(pattern);
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                suggestionsBoxVerticalOffset: 10,
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    color: GlobalColors.lightGrey,
                    offsetX: -20,
                    borderRadius: BorderRadius.circular(10)),
                itemBuilder: (context, suggestion) {
                  if (suggestion is Team) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        color: GlobalColors.lightGrey,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(suggestion.name,
                              style: Get.textTheme.bodyText1!.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        )),
                      ),
                    );
                  } else {
                    return Container(
                      color: GlobalColors.lightGrey,
                    );
                  }
                },
                onSuggestionSelected: onSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
