import '../model/advent_problem.dart';

typedef Pair = (int, int);

class Day02 extends AdventProblem {
  Day02() : super(2);

  int countRows(List<List<int>> grid) {
    int counter = 0;
    grid.forEach((row) {
      if (doesRowCount(row)) {
        counter++;
      }
    });
    return counter;
  }

  bool doesRowCount(List<int> row) {
    bool ascending = true;
    bool descending = true;
    bool diffByLessThanThree = true;

    for (int i = 0; i < row.length; i++) {
      if (i > 0) {
        if (row[i - 1] >= row[i]) {
          ascending = false;
        }
        if (row[i - 1] <= row[i]) {
          descending = false;
        }
        if ((row[i - 1] - row[i]).abs() > 3) {
          diffByLessThanThree = false;
        }
      }
    }

    return (ascending || descending) && diffByLessThanThree;
  }

  int countRowsP2(List<List<int>> grid) {
    int counter = 0;
    grid.forEach((row) {
      if (validateRowP2(row, 0)) {
        counter++;
      }
    });
    return counter;
  }

  bool validateRowP2(List<int> row, int idx) {
    if (row.length == idx) {
      return false;
    }

    List<int> copy = [...row];
    copy.removeAt(idx);

    if (doesRowCount(copy)) {
      return true;
    }

    return validateRowP2(row, (idx + 1));
  }

  @override
  int solvePart1() {
    List<List<int>> grid = input.getIntGrid();
    return countRows(grid);
  }

  @override
  int solvePart2() {
    List<List<int>> grid = input.getIntGrid();
    return countRowsP2(grid);
  }
}
