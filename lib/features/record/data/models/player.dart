import 'dart:convert';

class Player {
  final String firstName;
  final String lastName;
  final int age;
  final int shirtNumber;

  Player(
      {this.firstName = '',
      this.lastName = '',
      this.age = 0,
      this.shirtNumber = 0});

  String get name => "${this.firstName} ${this.lastName}";

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'shirtNumber': shirtNumber,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      age: map['age']?.toInt() ?? 0,
      shirtNumber: map['shirtNumber']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) => Player.fromMap(json.decode(source));
}
