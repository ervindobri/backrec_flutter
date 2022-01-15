import 'package:backrec_flutter/features/record/data/models/player.dart';

class Team {
  late final String name; // club name
  final int founded; //year
  final List<Player> players;

  Team({this.name = '', this.founded = 0000, this.players = const []});
}
