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

  int getSumP2(String inputStr, int index) {
    if ((index + 4) >= inputStr.length) {
      return 0;
    }

    if (inputStr.substring(index, (index + 4)) == 'mul(') {
      index += 4;
      int a;
      int b;
      (a, index) = getNum(inputStr, index);

      if (a == -1) {
        return 0;
      }

      if (inputStr[index] != ',') {
        return 0;
      }

      index++;

      (b, index) = getNum(inputStr, index);

      if (b == -1) {
        return 0;
      }

      if (inputStr[index] != ')') {
        return 0;
      }

      return a * b;
    }

    index++;

    return 0;
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

  bool getDont(String inputStr, int index) {
    if ((index + 7) >= inputStr.length) {
      return false;
    }

    if (inputStr.substring(index, (index + 7)) == "don't()") {
      return true;
    }

    return false;
  }

  bool getDo(String inputStr, int index) {
    if ((index + 4) >= inputStr.length) {
      return false;
    }

    if (inputStr.substring(index, (index + 4)) == "do()") {
      return true;
    }

    return false;
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

  int traverseInputP2(String inputStr) {
    int i = 0;
    int sum = 0;
    int mul;
    bool dont = false;

    while (i < inputStr.length) {
      if (!dont) {
        mul = getSumP2(inputStr, i);
        sum += mul;
      } else {
        dont = !getDo(inputStr, i);
      }

      if (!dont) {
        dont = getDont(inputStr, i);
      }

      i++;
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
    String inputStr = input.getString();
    return traverseInputP2(inputStr);
  }
}
