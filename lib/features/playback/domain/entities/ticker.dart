class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(Duration(milliseconds: 100), (x) {
      return x;
    });
  }
}
