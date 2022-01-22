import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:backrec_flutter/features/record/data/models/filter.dart';

/// Parse a created marker on a video. A video may contain multiple markers like this.
///
/// Setting [startPosition], [endPosition] and [filters] are obligatory.
class Marker {
  int? id;
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
      {this.id = 0,
      this.icon,
      this.startPosition = Duration.zero,
      this.endPosition = Duration.zero,
      this.filters = const []});

  @override
  String toString() {
    return 'Marker(icon: $icon, startPosition: $startPosition, endPosition: $endPosition, filters: $filters)';
  }

  Map<String, dynamic> toMap() {
    print(startPosition.inMilliseconds);
    print(endPosition.inMilliseconds);
    return {
      'id': this.id ?? DateTime.now().millisecondsSinceEpoch,
      'start_position': startPosition.inMilliseconds,
      'end_position': endPosition.inMilliseconds,
      'filters': filters.map((e) {
        switch (e.runtimeType) {
          case TeamFilter:
            return (e as TeamFilter).toMap();
          case PlayerFilter:
            return (e as PlayerFilter).toMap();
          case TypeFilter:
            return (e as TypeFilter).toMap();
          case RatingFilter:
            return (e as RatingFilter).toMap();
          default:
            return "";
        }
      }).toList(),
    };
  }

  factory Marker.fromMap(Map<String, dynamic> map) {
    print(map);
    final startMilliseconds = map['start_position'] as int;
    final endMilliseconds = map['end_position'] as int;
    print("$startMilliseconds $endMilliseconds");
    final List<Filter> filters = (map['filters'] as List<dynamic>).map((e) {
      switch (e.runtimeType) {
        case TeamFilter:
          return TeamFilter.fromJson(e);
        case PlayerFilter:
          return PlayerFilter.fromJson(e);
        case TypeFilter:
          return TypeFilter.fromJson(e);
        case RatingFilter:
          return RatingFilter.fromJson(e);
        default:
          return NanFilter();
      }
    }).toList();
    return Marker(
        id: map['id'] ?? DateTime.now().millisecondsSinceEpoch,
        startPosition: Duration(
            minutes: ((startMilliseconds / 1000) / 60).floor(),
            seconds: ((startMilliseconds / 1000) % 60).floor(),
            milliseconds: ((startMilliseconds / 1000).floor())),
        endPosition: Duration(
            minutes: ((endMilliseconds / 1000) / 60).floor(),
            seconds: ((endMilliseconds / 1000) % 60).floor(),
            milliseconds: ((endMilliseconds / 1000).floor())),
        filters: filters);
  }

  String toJson() => json.encode(toMap());

  factory Marker.fromJson(String source, int index) =>
      Marker.fromMap(json.decode(source));
}
