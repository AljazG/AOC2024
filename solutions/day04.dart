import '../model/advent_problem.dart';

class Day04 extends AdventProblem {
  Day04() : super(4);

  late List<List<int>> xGrid;

  int getXmasCountAt(
      List<String> grid, int i, int j, String xmas, bool addToGrid) {
    int left = findLeft(grid, i, j, xmas, addToGrid);
    int right = findRight(grid, i, j, xmas, addToGrid);
    int up = findUp(grid, i, j, xmas, addToGrid);
    int down = findDown(grid, i, j, xmas, addToGrid);
    int diagonals = findDiagonals(grid, i, j, xmas, addToGrid);
    return left + right + up + down + diagonals;
  }

  int findLeft(List<String> grid, int i, int j, String xmas, bool addToGrid) {
    if (!canLeft(grid, i, j, xmas)) {
      return 0;
    }

    String word = "";

    for (int idx = j; idx > j - xmas.length; idx--) {
      word += grid.elementAt(i)[idx];
    }

    return word == xmas ? 1 : 0;
  }

  int findRight(List<String> grid, int i, int j, String xmas, bool addToGrid) {
    if (!canRight(grid, i, j, xmas)) {
      return 0;
    }

    String word = "";

    for (int idx = j; idx < j + xmas.length; idx++) {
      word += grid.elementAt(i)[idx];
    }

    return word == xmas ? 1 : 0;
  }

  int findUp(List<String> grid, int i, int j, String xmas, bool addToGrid) {
    if (!canUp(grid, i, j, xmas)) {
      return 0;
    }

    String word = "";

    for (int idx = i; idx > i - xmas.length; idx--) {
      word += grid.elementAt(idx)[j];
    }

    return word == xmas ? 1 : 0;
  }

  int findDown(List<String> grid, int i, int j, String xmas, bool addToGrid) {
    if (!canDown(grid, i, j, xmas)) {
      return 0;
    }

    String word = "";

    for (int idx = i; idx < i + xmas.length; idx++) {
      word += grid.elementAt(idx)[j];
    }

    return word == xmas ? 1 : 0;
  }

  int findDiagonals(
      List<String> grid, int i, int j, String xmas, bool addToGrid) {
    int ur = findUr(grid, i, j, xmas, addToGrid);
    int ul = findUl(grid, i, j, xmas, addToGrid);
    int br = findBr(grid, i, j, xmas, addToGrid);
    int bl = findBl(grid, i, j, xmas, addToGrid);
    return ur + ul + br + bl;
  }

  int findUr(List<String> grid, int i, int j, String xmas, bool addToGrid) {
    if (!canUp(grid, i, j, xmas) || !canRight(grid, i, j, xmas)) {
      return 0;
    }

    String word = "";

    int a = i;
    int b = j;

    for (int idx = 0; idx < xmas.length; idx++) {
      word += grid.elementAt(a)[b];
      a--;
      b++;
    }

    if (addToGrid && word == xmas) {
      xGrid[i - 1][j + 1]++;
    }

    return word == xmas ? 1 : 0;
  }

  int findUl(List<String> grid, int i, int j, String xmas, bool addToGrid) {
    if (!canUp(grid, i, j, xmas) || !canLeft(grid, i, j, xmas)) {
      return 0;
    }

    String word = "";

    int a = i;
    int b = j;

    for (int idx = 0; idx < xmas.length; idx++) {
      word += grid.elementAt(a)[b];
      a--;
      b--;
    }

    if (addToGrid && word == xmas) {
      xGrid[i - 1][j - 1]++;
    }

    return word == xmas ? 1 : 0;
  }

  int findBr(List<String> grid, int i, int j, String xmas, bool addToGrid) {
    if (!canDown(grid, i, j, xmas) || !canRight(grid, i, j, xmas)) {
      return 0;
    }

    String word = "";

    int a = i;
    int b = j;

    for (int idx = 0; idx < xmas.length; idx++) {
      word += grid.elementAt(a)[b];
      a++;
      b++;
    }

    if (addToGrid && word == xmas) {
      xGrid[i + 1][j + 1]++;
    }

    return word == xmas ? 1 : 0;
  }

  int findBl(List<String> grid, int i, int j, String xmas, bool addToGrid) {
    if (!canDown(grid, i, j, xmas) || !canLeft(grid, i, j, xmas)) {
      return 0;
    }

    String word = "";

    int a = i;
    int b = j;

    for (int idx = 0; idx < xmas.length; idx++) {
      word += grid.elementAt(a)[b];
      a++;
      b--;
    }

    if (addToGrid && word == xmas) {
      xGrid[i + 1][j - 1]++;
    }

    return word == xmas ? 1 : 0;
  }

  bool canUp(List<String> grid, int i, int j, String xmas) {
    return i - xmas.length >= -1;
  }

  bool canDown(List<String> grid, int i, int j, String xmas) {
    return i + xmas.length < grid.length + 1;
  }

  bool canRight(List<String> grid, int i, int j, String xmas) {
    return j + xmas.length < grid.elementAt(i).length + 1;
  }

  bool canLeft(List<String> grid, int i, int j, String xmas) {
    return j - xmas.length >= -1;
  }

  @override
  int solvePart1() {
    List<String> grid = input.getList();
    int sum = 0;

    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid.elementAt(i).length; j++) {
        sum += getXmasCountAt(grid, i, j, "XMAS", false);
      }
    }

    return sum;
  }

  @override
  int solvePart2() {
    List<String> grid = input.getList();

    xGrid = [];

    for (int i = 0; i < grid.length; i++) {
      xGrid.add([]);
      for (int j = 0; j < grid.elementAt(i).length; j++) {
        xGrid.elementAt(i).add(0);
      }
    }

    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid.elementAt(i).length; j++) {
        getXmasCountAt(grid, i, j, "MAS", true);
      }
    }

    int sum = 0;

    for (int i = 0; i < xGrid.length; i++) {
      for (int j = 0; j < xGrid.elementAt(i).length; j++) {
        if (xGrid[i][j] > 1) {
          sum++;
        }
      }
    }

    return sum;
  }
}
