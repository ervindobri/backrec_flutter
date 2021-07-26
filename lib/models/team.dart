class Player {
  final String firstName;
  final String lastName;
  final int age;
  final int shirtNumber;

  Player(
      {required this.firstName,
      required this.lastName,
      required this.age,
      required this.shirtNumber});
}

class Team {
  late final String name; // club name
  final int founded; //year
  final List<Player> players;

  Team({required this.name, required this.founded, this.players = const []});
}
