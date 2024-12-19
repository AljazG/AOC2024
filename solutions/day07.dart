import '../model/advent_problem.dart';

class Day07 extends AdventProblem {
  Day07() : super(7);

  late List<int> results;
  late List<List<int>> numbers;

  static final int PLUS = 0;
  static final int MUL = 1;
  static final int OR = 2;

  parseInput(List<String> input) {
    results = [];
    numbers = [];
    for (int i = 0; i < input.length; i++) {
      var split = input[i].split(':');
      results.add(int.parse(split[0]));
      List<int> line = [];
      var numStringList = split[1].trim().split(' ');

      for (var numStr in numStringList) {
        line.add(int.parse(numStr));
      }
      numbers.add(line);
    }
  }

  bool isValid(List<int> numbers, int goal, int i, int sum) {
    if (sum > goal) {
      return false;
    }

    if (sum == goal && i + 1 == numbers.length) {
      return true;
    }

    if (i + 1 >= numbers.length) {
      return false;
    }

    int mul = 0;
    int plus = 0;

    if (i == 0) {
      mul = numbers[i] * numbers[i + 1];
      plus = (numbers[i] + numbers[i + 1]);
    } else {
      mul = sum * numbers[i + 1];
      plus = sum + numbers[i + 1];
    }

    if (isValid(numbers, goal, i + 1, plus)) {
      return true;
    }
    if (isValid(numbers, goal, i + 1, mul)) {
      return true;
    }

    return false;
  }

  bool isValidP2(List<int> numbers, int goal, int i, int sum) {
    if (sum > goal) {
      return false;
    }

    if (sum == goal && i + 1 == numbers.length) {
      return true;
    }

    if (i + 1 >= numbers.length) {
      return false;
    }

    int mul = 0;
    int plus = 0;
    int or = 0;

    if (i == 0) {
      mul = numbers[i] * numbers[i + 1];
      plus = (numbers[i] + numbers[i + 1]);
      or = int.parse(numbers[i].toString() + numbers[i + 1].toString());
    } else {
      mul = sum * numbers[i + 1];
      plus = sum + numbers[i + 1];
      or = int.parse(sum.toString() + numbers[i + 1].toString());
    }

    if (isValidP2(numbers, goal, i + 1, plus)) {
      return true;
    }
    if (isValidP2(numbers, goal, i + 1, mul)) {
      return true;
    }
    if (isValidP2(numbers, goal, i + 1, or)) {
      return true;
    }

    return false;
  }

  bool areAllOpsMul(List<int> ops) {
    for (int op in ops) {
      if (op == PLUS) {
        return false;
      }
    }
    return true;
  }

  @override
  int solvePart1() {
    var lines = input.getList();
    parseInput(lines);
    var validResults = [];
    for (int i = 0; i < results.length; i++) {
      if (isValid(numbers[i], results[i], 0, 0)) {
        validResults.add(results[i]);
      }
    }

    return validResults.reduce((a, b) => a + b);
  }

  @override
  int solvePart2() {
    var lines = input.getList();
    parseInput(lines);
    var validResults = [];
    for (int i = 0; i < results.length; i++) {
      if (isValidP2(numbers[i], results[i], 0, 0)) {
        validResults.add(results[i]);
      }
    }

    return validResults.reduce((a, b) => a + b);
  }
}
