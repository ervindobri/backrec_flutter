extension VideoNameParser on String {
  String get galleryParsed {
    final string = "trim.40B6B41B-D801-4212-AFDB-0886EDFED0A7.MOV";
    const start = "trim.";
    const end = ".MOV"; //TODO: multiple extensions

    final startIndex = this.indexOf('trim.');
    final endIndex = this.indexOf(end, startIndex + start.length);

    final result = this.substring(startIndex + start.length, endIndex);
    print(result);
    return result; // brown fox jumps
  }

  String get parsed {
    const extensions = [".mp4", '.MOV', '.mov'];
    for (var item in extensions) {
      final endIndex = this.indexOf(item, 0);
      if (endIndex != -1) {
        final result = this.substring(0, endIndex);
        return result;
      }
    }
    return this;
  }

  String get parsedPath {
    return this.split('/').last.parsed;
  }
}
