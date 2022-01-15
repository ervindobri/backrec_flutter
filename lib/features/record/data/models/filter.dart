import 'dart:convert';

import 'package:backrec_flutter/features/record/data/models/player.dart';
import 'package:backrec_flutter/features/record/data/models/team.dart';

enum MarkerType { GOAL, SKILL, ATTEMPT, FUNNY, ANALYZE, TEACHING }

extension ParseToString on MarkerType {
  String get parse {
    return this.toString().split('.').last.toLowerCase();
  }
}
abstract class Filter {}

class PlayerFilter extends Filter {
  final Player? player1;
  final Player? player2;
  PlayerFilter(this.player1, this.player2);

  Map<String, dynamic> toMap() {
    return {
      'player1': player1?.toMap(),
      'player2': player2?.toMap(),
    };
  }

  factory PlayerFilter.fromMap(Map<String, dynamic> map) {
    return PlayerFilter(
      map['player1'] != null ? Player.fromMap(map['player1']) : null,
      map['player2'] != null ? Player.fromMap(map['player2']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerFilter.fromJson(String source) => PlayerFilter.fromMap(json.decode(source));
}

class TeamFilter extends Filter {
  final Team team;
  TeamFilter(this.team);
}

class TypeFilter extends Filter {
  final List<MarkerType> types;
  TypeFilter(this.types);
}

class RatingFilter extends Filter {
  final double rating;
  RatingFilter(this.rating);
}
