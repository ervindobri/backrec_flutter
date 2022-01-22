import 'dart:convert';

import 'package:backrec_flutter/features/record/data/models/player.dart';

class Team {
  final String name; // club name
  final int founded; //year
  final List<Player> players;

  Team({this.name = '', this.founded = 0000, this.players = const []});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'founded': founded,
      'players': players.map((x) => x.toMap()).toList(),
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      name: map['name'] as String,
      founded: map['founded']?.toInt() ?? 0,
      players: List<Player>.from(map['players']?.map((x) => Player.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Team.fromJson(String source) => Team.fromMap(json.decode(source));
}
