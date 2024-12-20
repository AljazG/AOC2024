import 'dart:io';

class Input {
  late String _inputString;
  late List<String> _inputList;

  Input(int day)
      : _inputList = _readInputDayAsList(day),
        _inputString = _readInputDay(day);

  static String _createInputPath(int day) {
    final dayString = day.toString().padLeft(2, '0');
    return './input/day$dayString.txt';
  }

  static String _readInputDay(int day) {
    return _readInput(_createInputPath(day));
  }

  static String _readInput(String input) {
    return File(input).readAsStringSync();
  }

  static List<String> _readInputDayAsList(int day) {
    return _readInputAsList(_createInputPath(day));
  }

  static List<String> _readInputAsList(String input) {
    return File(input).readAsLinesSync();
  }

  String getString() => _inputString;

  List<String> getList() => _inputList;

  List<String> getPerWhitespace() {
    return _inputString.split(RegExp(r'\s\n'));
  }

  List<String> getBy(String pattern) {
    return _inputString.split(pattern);
  }

  List<String> getByRegex(RegExp regex) {
    return _inputString.split(regex);
  }

  List<List<int>> getIntGrid() {
    return getIntGridByPattern(' ');
  }

  List<List<String>> getCharacterGrid() {
    var list = _inputList;
    var grid = List.generate(
      list.length,
      (i) => List.generate(list[0].length, (j) => list[i][j]),
    );
    return grid;
  }

  List<List<int>> getIntGridByPattern(String pattern) {
    int rows = _inputList.length;

    List<List<int>> grid = [];

    for (int i = 0; i < rows; i++) {
      List<int> row = _inputList[i].split(pattern).map(int.parse).toList();
      grid.add(row);
    }

    return grid;
  }
}
