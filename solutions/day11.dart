import 'dart:collection';

import '../model/advent_problem.dart';

class Day11 extends AdventProblem {
  Day11() : super(11);

  LinkedList<Stone> getStoneList() {
    LinkedList<Stone> stones = LinkedList<Stone>();
    for (Stone stone in input
        .getString()
        .split(" ")
        .toList()
        .map((s) => Stone(int.parse(s)))) {
      stones.add(stone);
    }
    return stones;
  }

  Map<String, int> getStoneMap() {
    Map<String, int> stones = Map();
    for (String stone in input.getString().split(" ").toList()) {
      stones[stone] == null
          ? stones[stone] = 1
          : stones[stone] = stones[stone]! + 1;
    }
    return stones;
  }

  void blink(LinkedList<Stone> stones) {
    List<Stone> toSplit = [];

    var iterator = stones.iterator;
    while (iterator.moveNext()) {
      Stone stone = iterator.current;
      if (stone.value == 0) {
        stone.value = 1;
        continue;
      }

      if (stone.toString().length % 2 == 0) {
        toSplit.add(stone);
        continue;
      }

      stone.value *= 2024;
    }

    for (Stone stone in toSplit) {
      String num = stone.toString();
      Stone left = Stone(int.parse(num.substring(0, (num.length / 2).round())));
      Stone right =
          Stone(int.parse(num.substring((num.length / 2).round(), num.length)));
      Stone? prev = stone.previous;
      Stone? next = stone.next;

      if (prev != null) {
        prev.insertAfter(left);
        stone.unlink();
      } else if (next != null) {
        next.insertBefore(left);
        stone.unlink();
      } else {
        stones = LinkedList();
        stones.add(left);
      }

      left.insertAfter(right);
    }
  }

  Map<String, int> blinkP2(Map<String, int> stones) {
    Map<String, int> toReplace = Map();
    for (final entry in stones.entries) {
      if (entry.key == '0') {
        toReplace['1'] == null
            ? toReplace['1'] = entry.value
            : toReplace['1'] = toReplace['1']! + entry.value;
        continue;
      }

      if (entry.key.length % 2 == 0) {
        String left =
            int.parse(entry.key.substring(0, (entry.key.length / 2).round()))
                .toString();
        String right = int.parse(entry.key
                .substring((entry.key.length / 2).round(), entry.key.length))
            .toString();
        toReplace[left] == null
            ? toReplace[left] = entry.value
            : toReplace[left] = toReplace[left]! + entry.value;
        toReplace[right] == null
            ? toReplace[right] = entry.value
            : toReplace[right] = toReplace[right]! + entry.value;
        continue;
      }
      int num = int.parse(entry.key) * 2024;

      toReplace[num.toString()] == null
          ? toReplace[num.toString()] = entry.value
          : toReplace[num.toString()] =
              toReplace[num.toString()]! + entry.value;
    }
    return toReplace;
  }

  @override
  int solvePart1() {
    LinkedList<Stone> stones = getStoneList();

    int blinks = 25;

    for (int i = 0; i < blinks; i++) {
      blink(stones);
    }

    return stones.length;
  }

  @override
  int solvePart2() {
    Map<String, int> stones = getStoneMap();

    int blinks = 75;

    for (int i = 0; i < blinks; i++) {
      stones = blinkP2(stones);
    }

    return stones.values.reduce((a, b) => a + b);
  }
}

base class Stone extends LinkedListEntry<Stone> {
  int value;
  Stone(this.value);

  @override
  String toString() {
    return '$value';
  }
}
