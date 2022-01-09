class Ticker {
  const Ticker();
  //TODO: make more frequent ticks
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) {
      print(x);
      return x;
    });
  }
}
