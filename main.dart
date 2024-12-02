import 'model/advent_problem.dart';
import 'solutions/day01.dart';
import 'solutions/day02.dart';

bool showLatest = true;

final days = <AdventProblem>[Day01(), Day02()];

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
