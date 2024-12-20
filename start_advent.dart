import 'dart:io';

void main() {
  const String solutionsDir = 'solutions';
  const String inputDir = 'input';
  Directory(solutionsDir).createSync();
  Directory(inputDir).createSync();

  for (int day = 1; day <= 25; day++) {
    String dayStr = day.toString().padLeft(2, '0');
    String dartFilename = '$solutionsDir/day$dayStr.dart';

    if (!File(dartFilename).existsSync()) {
      File(dartFilename).writeAsStringSync(getContentForDay(day, dayStr));
      print('Created $dartFilename');
    } else {
      print('$dartFilename already exists. Skipping...');
    }

    String txtFilename = '$inputDir/day$dayStr.txt';

    if (!File(txtFilename).existsSync()) {
      File(txtFilename).writeAsStringSync('');
      print('Created $txtFilename');
    } else {
      print('$txtFilename already exists. Skipping...');
    }
  }
}

String getContentForDay(int day, String dayStr) {
  return '''
import '../model/advent_problem.dart';

class Day$dayStr extends AdventProblem {
  Day$dayStr() : super($day);

  @override
  int solvePart1() {
    return 0;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
''';
}
