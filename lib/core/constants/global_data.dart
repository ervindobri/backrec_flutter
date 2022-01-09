import 'package:backrec_flutter/models/player.dart';
import 'package:backrec_flutter/models/team.dart';

class GlobalData {
  static List<Team> teams = [
    Team(name: "Fiatalok", founded: 1991, players: [
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 1),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 2),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 4),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 3),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 98),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 99),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 33),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 8),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 7),
      Player(firstName: "Feri", lastName: "Vagany", age: 21, shirtNumber: 9),
      Player(
          firstName: "Jozsika", lastName: "Embolo", age: 20, shirtNumber: 10),
    ]),
    Team(name: "Fiatalok2", founded: 1992, players: [
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 1),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 2),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 4),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 3),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 98),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 99),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 33),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 8),
      Player(firstName: "Jozsi", lastName: "Ferencz", age: 21, shirtNumber: 7),
      Player(firstName: "Feri", lastName: "Vagany", age: 21, shirtNumber: 9),
      Player(
          firstName: "Jozsika", lastName: "Embolo", age: 20, shirtNumber: 10),
    ]),
    Team(name: "Oregek", founded: 1991, players: [
      Player(
          firstName: "Jozsidsa", lastName: "Ferencz", age: 41, shirtNumber: 1),
      Player(firstName: "Dudi", lastName: "Koma", age: 31, shirtNumber: 2),
      Player(firstName: "Dido", lastName: "Laszlo", age: 31, shirtNumber: 4),
      Player(firstName: "Nemet", lastName: "Smith", age: 51, shirtNumber: 3),
      Player(firstName: "Janos", lastName: "Kovacs", age: 33, shirtNumber: 98),
      Player(firstName: "Jano", lastName: "Ferencz", age: 41, shirtNumber: 99),
      Player(firstName: "Janos", lastName: "Ven", age: 37, shirtNumber: 33),
      Player(firstName: "Jozsi", lastName: "Eross", age: 34, shirtNumber: 8),
      Player(firstName: "Laci", lastName: "Gyenge", age: 32, shirtNumber: 7),
      Player(firstName: "Istvan", lastName: "Komoly", age: 35, shirtNumber: 9),
      Player(
          firstName: "Jozsika", lastName: "Embolo", age: 20, shirtNumber: 10),
    ]),
  ];

  static List markerTypes = [
    "GOAL",
    "ATTEMPT",
    "FUNNY",
    "ANALYZE",
    "SKILL",
    "TEACHING"
  ];

  static Duration clipLength  = Duration(seconds: 12);

  static List getTeams(String pattern) {
    return teams
        .where((element) =>
            element.name.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }
}
