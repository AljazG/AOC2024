import '../utils/input_util.dart';

typedef SolutionWithTime = (int, Duration);
typedef Solution = int Function();

abstract class AdventProblem {
  final int dayNum;
  final Input input;

  AdventProblem(int day)
      : dayNum = day,
        input = Input(day);

  int solvePart1();
  int solvePart2();

  void printSolution() {
    SolutionWithTime part1 = _solveAndTime(solvePart1);
    SolutionWithTime part2 = _solveAndTime(solvePart2);
    print('-------------------------');
    print('         Day $dayNum        ');
    print('Solution for part one: ${_formatResult(part1)}');
    print('Solution for part two: ${_formatResult(part2)}');
    print('\n');
  }

  SolutionWithTime _solveAndTime(Solution solve) {
    final stopwatch = Stopwatch()..start();
    int solution = solve();
    stopwatch.stop();
    return (solution, stopwatch.elapsed);
  }

  String _formatResult(SolutionWithTime result) {
    final (solution, duration) = result;
    return '$solution - Took ${duration.inMilliseconds} milliseconds';
  }
}
