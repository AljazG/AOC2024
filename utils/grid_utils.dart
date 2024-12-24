import 'general_utils.dart';

void printCharacterGrid(List<List<String>> grid) {
  final buffer = StringBuffer();
  for (List<String> row in grid) {
    for (int i = 0; i < row.length; i++) {
      buffer.write(row[i]);
      if (i < row.length - 1) {
        buffer.write(" ");
      }
    }
    buffer.writeln();
  }
  print(buffer);
}

void printIntGrid(List<List<int>> grid) {
  final buffer = StringBuffer();
  for (List<int> row in grid) {
    for (int i = 0; i < row.length; i++) {
      if (row[i] == MAX_INT) {
        buffer.write("MAXX");
      } else {
        buffer.write(row[i].toString());
      }

      if (i < row.length - 1) {
        buffer.write(" ");
      }
    }
    buffer.writeln();
  }
  print(buffer);
}
