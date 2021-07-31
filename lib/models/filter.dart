import 'package:backrec_flutter/models/player.dart';
import 'package:backrec_flutter/models/team.dart';

enum MarkerType { GOAL, SKILL, ATTEMPT, FUNNY, ANALYZE, TEACHING }

abstract class Filter {}

class PlayerFilter extends Filter {
  final Player player1;
  final Player player2;
  PlayerFilter(this.player1, this.player2);
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
