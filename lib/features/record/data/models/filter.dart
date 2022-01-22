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

  factory PlayerFilter.fromJson(String source) =>
      PlayerFilter.fromMap(json.decode(source));
}

class TeamFilter extends Filter {
  final Team team;
  TeamFilter(this.team);

  Map<String, dynamic> toMap() {
    return {
      'team': team.toMap(),
    };
  }

  factory TeamFilter.fromMap(Map<String, dynamic> map) {
    return TeamFilter(
      Team.fromMap(map['team']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TeamFilter.fromJson(String source) =>
      TeamFilter.fromMap(json.decode(source));
}

class TypeFilter extends Filter {
  final List<MarkerType> types;
  TypeFilter(this.types);

  Map<String, dynamic> toMap() {
    return {
      'types': types.map((x) => x.parse).toList(),
    };
  }

  factory TypeFilter.fromMap(Map<String, dynamic> map) {
    return TypeFilter(
      List<MarkerType>.from(map['types']?.map((x) =>
          MarkerType.values.firstWhere((element) => element.parse == x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeFilter.fromJson(String source) =>
      TypeFilter.fromMap(json.decode(source));
}

class RatingFilter extends Filter {
  final double rating;
  RatingFilter(this.rating);

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
    };
  }

  factory RatingFilter.fromMap(Map<String, dynamic> map) {
    return RatingFilter(
      map['rating']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RatingFilter.fromJson(String source) => RatingFilter.fromMap(json.decode(source));
}

class NanFilter extends Filter {}