import 'model/advent_problem.dart';
import 'solutions/day01.dart';
import 'solutions/day02.dart';
import 'solutions/day03.dart';
import 'solutions/day04.dart';
import 'solutions/day05.dart';
import 'solutions/day06.dart';

bool showLatest = true;

final days = <AdventProblem>[
  Day01(),
  Day02(),
  Day03(),
  Day04(),
  Day05(),
  Day06()
];

void checkArgs(List<String?> args) {
  for (var arg in args) {
    if (arg.isAllArg()) {
      showLatest = false;
    }
  }
}

void main(List<String?> args) {
  checkArgs(args);

  showLatest
      ? days.last.printSolution()
      : days.forEach((day) => day.printSolution());
}

extension argsMatcher on String? {
  bool isAllArg() {
    return this == '-a' || this == '-all';
  }
}
