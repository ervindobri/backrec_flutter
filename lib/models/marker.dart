import 'package:backrec_flutter/models/filter.dart';
import 'package:flutter/material.dart';

/// Parse a created marker on a video. A video may contain multiple markers like this.
///
/// Setting [startPosition], [endPosition] and [filters] are obligatory.
class Marker {
  final Icon? icon;
  Duration startPosition;
  Duration endPosition;
  List<Filter> filters;

  /// Parse a created marker on a video. A video may contain multiple markers like this.
  ///
  /// icon - to be displayed on the bars' marker pin, can be null
  ///
  /// startPosition - where the marker starts (usually endPosition - 12 sec)
  ///
  /// endPosition - where the marker ends
  ///
  /// filters - players, teams, type(goal,skill,attempt etc.), rating, clipLength
  ///
  Marker(
      {this.icon,
      this.startPosition = Duration.zero,
      this.endPosition = Duration.zero,
      this.filters = const []});

  @override
  String toString() {
    return 'Marker(icon: $icon, startPosition: $startPosition, endPosition: $endPosition, filters: $filters)';
  }
}
