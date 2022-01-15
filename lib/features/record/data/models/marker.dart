import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:backrec_flutter/features/record/data/models/filter.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'start_position': startPosition.inMilliseconds,
      'end_position': endPosition.inMilliseconds,
      'filters': filters,
    };
  }

  factory Marker.fromMap(Map<String, dynamic> map) {
    final startMilliseconds = map['start_position'] as int;
    final endMilliseconds = map['start_position'] as int;
    return Marker(
        startPosition: Duration(
            minutes: ((startMilliseconds / 1000) / 60).floor(),
            seconds: ((startMilliseconds / 1000) % 60).floor(),
            milliseconds: ((startMilliseconds / 1000).floor())),
        endPosition: Duration(
            minutes: ((endMilliseconds / 1000) / 60).floor(),
            seconds: ((endMilliseconds / 1000) % 60).floor(),
            milliseconds: ((endMilliseconds / 1000).floor())),
        filters: map['filters']);
  }

  String toJson() => json.encode(toMap());

  factory Marker.fromJson(String source) => Marker.fromMap(json.decode(source));
}
