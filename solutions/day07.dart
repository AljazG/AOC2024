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

  bool isValid(
      List<int> numbers, List<int> operators, int goal, int operatorIdx) {
    int sum = 0;
    for (int i = 1; i < numbers.length; i++) {
      if (operators[i - 1] == MUL) {
        if (sum == 0) {
          sum = numbers[i - 1] * numbers[i];
        } else {
          sum *= numbers[i];
        }
      } else if (operators[i - 1] == PLUS) {
        if (i == 1) {
          sum = (numbers[i - 1] + numbers[i]);
        } else {
          sum = sum + numbers[i];
        }
      } 
    }

    if (sum == goal) {
      return true;
    }

    if (operatorIdx >= operators.length) {
      return false;
    }

    if (areAllOpsMul(operators)) {
      return false;
    }

    operators[operatorIdx] = MUL;
    bool path1 = isValid(numbers, operators, goal, operatorIdx + 1);

    operators[operatorIdx] = PLUS;
    bool path2 = isValid(numbers, operators, goal, operatorIdx + 1);

    return path1 || path2;
  }

  bool isValidP2(
      List<int> numbers, List<int> operators, int goal, int operatorIdx) {
    int sum = 0;
    for (int i = 1; i < numbers.length; i++) {
      if (operators[i - 1] == MUL) {
        if (sum == 0) {
          sum = numbers[i - 1] * numbers[i];
        } else {
          sum *= numbers[i];
        }
      } else if (operators[i - 1] == PLUS) {
        if (i == 1) {
          sum = (numbers[i - 1] + numbers[i]);
        } else {
          sum = sum + numbers[i];
        }
      } else if (operators[i - 1] == OR) {
        if (i == 1) {
          sum = int.parse(numbers[i - 1].toString() + numbers[i].toString());
        } else {
          sum = int.parse(sum.toString() + numbers[i].toString());
        }
      }
      
    }

    if (sum == goal) {
      return true;
    }

    if (operatorIdx >= operators.length) {
      return false;
    }

    if (areAllOpsMul(operators)) {
      return false;
    }

    operators[operatorIdx] = MUL;
    bool path1 = isValidP2(numbers, operators, goal, operatorIdx + 1);
    operators[operatorIdx] = OR;
    bool path2 = isValidP2(numbers, operators, goal, operatorIdx + 1);
    operators[operatorIdx] = PLUS;
    bool path3 = isValidP2(numbers, operators, goal, operatorIdx + 1);

    return path1 || path2 || path3;
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
      var ops = List.generate(numbers[i].length - 1, (_) => PLUS);
      if (isValid(numbers[i], ops, results[i], 0)) {
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
      var ops = List.generate(numbers[i].length - 1, (_) => PLUS);
      if (isValidP2(numbers[i], ops, results[i], 0)) {
        validResults.add(results[i]);
      }
    }

    return validResults.reduce((a, b) => a + b);
  }
}
