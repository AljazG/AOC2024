import '../model/advent_problem.dart';

typedef Pair = (int, int);

class Day01 extends AdventProblem {
  Day01() : super(1);

  List<int> list1 = [];
  List<int> list2 = [];

  void _parseInput(List<int> inputList) {
    list1 = [];
    list2 = [];
    for (int i = 0; i < inputList.length; i = i + 2) {
      list1.add(inputList[i]);
      list2.add(inputList[i + 1]);
    }
  }

  List<Pair> constructPairList(List<int> first, List<int> second) {
    List<int> a = [...first];
    List<int> b = [...second];
    List<Pair> pairList = [];
    for (int i = 0; i < first.length; i++) {
      var smallestAIdx =
          a.asMap().entries.reduce((a, b) => a.value < b.value ? a : b).key;
      var smallestBIdx =
          b.asMap().entries.reduce((a, b) => a.value < b.value ? a : b).key;
      pairList.add((a[smallestAIdx], b[smallestBIdx]));
      a.removeAt(smallestAIdx);
      b.removeAt(smallestBIdx);
    }
    return pairList;
  }

  int calculateDistance(List<Pair> pairList) {
    int sum = 0;
    for (Pair pair in pairList) {
      int distance = (pair.$1 - pair.$2).abs();
      sum += distance;
    }
    return sum;
  }

  int calculateSimilarityScore() {
    int sum = 0;
    list1.forEach((num) {
      int occurences = getNumOfOccurences(list2, num);
      sum += occurences * num;
    });
    return sum;
  }

  int getNumOfOccurences(List<int> list, int num) {
    int occurences = 0;
    list.forEach((el) {
      if (el == num) {
        occurences++;
      }
    });
    return occurences;
  }

  @override
  int solvePart1() {
    List<int> inputList =
        input.getByRegex(RegExp('   |\n')).map(int.parse).toList();
    _parseInput(inputList);
    List<Pair> pairList = constructPairList(list1, list2);
    return calculateDistance(pairList);
  }

  @override
  int solvePart2() {
    List<int> inputList =
        input.getByRegex(RegExp('   |\n')).map(int.parse).toList();
    _parseInput(inputList);
    return calculateSimilarityScore();
  }
}
