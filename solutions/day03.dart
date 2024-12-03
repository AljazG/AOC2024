import '../model/advent_problem.dart';

typedef IndexSumPair = (int, int);

class Day03 extends AdventProblem {
  Day03() : super(3);

  IndexSumPair getSum(String inputStr, int index) {
    if ((index + 4) >= inputStr.length) {
      return (index + 1, 0);
    }

    if (inputStr.substring(index, (index + 4)) == 'mul(') {
      index += 4;
      int a;
      int b;
      (a, index) = getNum(inputStr, index);

      if (a == -1) {
        return (index + 1, 0);
      }

      if (inputStr[index] != ',') {
        return (index, 0);
      }

      index++;

      (b, index) = getNum(inputStr, index);

      if (b == -1) {
        return (index, 0);
      }

      if (inputStr[index] != ')') {
        return (index + 1, 0);
      }

      return (index + 1, a * b);
    }

    index++;

    return (index, 0);
  }

  (int, int) getNum(String inputStr, int index) {
    String num = '';

    for (int i = index; i < index + 3; i++) {
      if (int.tryParse(inputStr[i]) != null) {
        index++;
        num += inputStr[i];
      } else {
        break;
      }
    }

    if (num == '') {
      return (-1, index);
    }

    return (int.parse(num), index);
  }

  int traverseInput(String inputStr) {
    int i = 0;
    int sum = 0;
    int mul;

    while (i < inputStr.length) {
      (i, mul) = getSum(inputStr, i);
      sum += mul;
    }
    return sum;
  }

  @override
  int solvePart1() {
    String inputStr = input.getString();
    return traverseInput(inputStr);
  }

  @override
  int solvePart2() {
    return 0;
  }
}
