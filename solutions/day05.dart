import '../model/advent_problem.dart';

class Num {
  Num(this.num);
  int num;
  Set<int> before = Set();
  Set<int> after = Set();
}

class Day05 extends AdventProblem {
  Day05() : super(5);

  List<List<int>> parseInput(List<String> inputList, Map ruleMap) {
    List<List<int>> updateList = [];

    bool readingRules = true;
    for (String line in inputList) {
      if (readingRules) {
        if (line == "") {
          readingRules = false;
        } else {
          readRule(line, ruleMap);
        }
      } else {
        List<int> updates =
            line.split(',').map((str) => int.parse(str)).toList();
        updateList.add(updates);
      }
    }
    return updateList;
  }

  void readRule(String rule, ruleMap) {
    List<String> split = rule.split("|");
    int before = int.parse(split[0]);
    int after = int.parse(split[1]);

    Num first;
    Num second;

    if (!ruleMap.containsKey(before)) {
      first = Num(before);
    } else {
      first = ruleMap[before];
    }

    if (!ruleMap.containsKey(after)) {
      second = Num(after);
    } else {
      second = ruleMap[after];
    }

    first.after.add(after);
    second.before.add(before);

    ruleMap[before] = first;
    ruleMap[after] = second;
  }

  bool isListValid(List<int> numList, Map ruleMap) {
    for (int i = 0; i < numList.length; i++) {
      Num numRules = ruleMap[numList[i]];

      for (int beforeId = 0; beforeId < i; beforeId++) {
        if (numRules.after.contains(numList[beforeId])) {
          return false;
        }
      }

      for (int afterId = i + 1; afterId < numList.length; afterId++) {
        if (numRules.before.contains(numList[afterId])) {
          return false;
        }
      }
    }
    return true;
  }

  List<int> makeValid(List<int> numList, Map ruleMap) {
    for (int i = 0; i < numList.length; i++) {
      Num numRules = ruleMap[numList[i]];

      for (int beforeId = 0; beforeId < i; beforeId++) {
        if (numRules.after.contains(numList[beforeId])) {
          int num = numList[i];
          numList[i] = numList[beforeId];
          numList[beforeId] = num;
          return makeValid(numList, ruleMap);
        }
      }

      for (int afterId = i + 1; afterId < numList.length; afterId++) {
        if (numRules.before.contains(numList[afterId])) {
          int num = numList[i];
          numList[i] = numList[afterId];
          numList[afterId] = num;
          return makeValid(numList, ruleMap);
        }
      }
    }

    return numList;
  }

  @override
  int solvePart1() {
    List<String> inputList = input.getList();
    var map = Map();
    List<List<int>> updateList = parseInput(inputList, map);
    List<List<int>> validRows = [];
    for (List<int> row in updateList) {
      if (isListValid(row, map)) {
        validRows.add(row);
      }
    }

    int sum = 0;

    for (List<int> row in validRows) {
      sum += row[row.length ~/ 2];
    }

    return sum;
  }

  @override
  int solvePart2() {
    List<String> inputList = input.getList();
    var map = Map();
    List<List<int>> updateList = parseInput(inputList, map);
    List<List<int>> invalidRows = [];
    List<List<int>> correctedRows = [];

    for (List<int> row in updateList) {
      if (!isListValid(row, map)) {
        invalidRows.add(row);
      }
    }

    for (List<int> row in invalidRows) {
      correctedRows.add(makeValid(row, map));
    }

    int sum = 0;

    for (List<int> row in correctedRows) {
      sum += row[row.length ~/ 2];
    }

    return sum;
  }
}
