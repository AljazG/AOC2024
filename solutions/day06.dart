import '../model/advent_problem.dart';

typedef GuardStance = (Coords, int);
typedef Coords = (int, int);

class Day06 extends AdventProblem {
  Day06() : super(6);

  List guardChars = ["<", ">", "^", "v"];
  static final int LEFT = 0;
  static final int RIGHT = 1;
  static final int UP = 2;
  static final int DOWN = 3;

  var positions = Set<(int, int, int)>();

  GuardStance getGuardStance(List<List<String>> grid) {
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        int direction = guardChars.match(grid[i][j]);
        if (direction != -1) {
          return ((i, j), direction);
        }
      }
    }
    return ((0, 0), 0);
  }

  void fillGrid(GuardStance stance, List<List<String>> grid) {
    int i, j;
    (i, j) = stance.$1;
    int direction = stance.$2;

    if (outOfBouds((i, j), grid)) {
      return;
    }

    grid[i][j] = 'X';

    if (direction == LEFT) {
      if (outOfBouds((i, j - 1), grid)) {
        return;
      }
      if (grid[i][j - 1] == '#') {
        fillGrid(((i, j), UP), grid);
      } else {
        fillGrid(((i, j - 1), direction), grid);
      }
    }

    if (direction == RIGHT) {
      if (outOfBouds((i, j + 1), grid)) {
        return;
      }
      if (grid[i][j + 1] == '#') {
        fillGrid(((i, j), DOWN), grid);
      } else {
        fillGrid(((i, j + 1), direction), grid);
      }
    }

    if (direction == UP) {
      if (outOfBouds((i - 1, j), grid)) {
        return;
      }
      if (grid[i - 1][j] == '#') {
        fillGrid(((i, j), RIGHT), grid);
      } else {
        fillGrid(((i - 1, j), direction), grid);
      }
    }

    if (direction == DOWN) {
      if (outOfBouds((i + 1, j), grid)) {
        return;
      }
      if (grid[i + 1][j] == '#') {
        fillGrid(((i, j), LEFT), grid);
      } else {
        fillGrid(((i + 1, j), direction), grid);
      }
    }
  }

  bool outOfBouds(Coords coords, List<List<String>> grid) {
    if ((coords.$1 < 0 || coords.$1 >= grid.length)) {
      return true;
    }

    if ((coords.$2 < 0 || coords.$2 >= grid[0].length)) {
      return true;
    }

    return false;
  }

  bool isLoop(GuardStance stance, List<List<String>> grid) {
    int i, j;
    (i, j) = stance.$1;
    int direction = stance.$2;

    if (outOfBouds((i, j), grid)) {
      return false;
    }

    if (positions.contains((i, j, direction))) {
      return true;
    }

    positions.add((i, j, direction));

    if (direction == LEFT) {
      if (outOfBouds((i, j - 1), grid)) {
        return false;
      }
      if (grid[i][j - 1] == '#') {
        return isLoop(
          ((i, j), UP),
          grid,
        );
      } else {
        return isLoop(
          ((i, j - 1), direction),
          grid,
        );
      }
    }

    if (direction == RIGHT) {
      if (outOfBouds((i, j + 1), grid)) {
        return false;
      }
      if (grid[i][j + 1] == '#') {
        return isLoop(
          ((i, j), DOWN),
          grid,
        );
      } else {
        return isLoop(
          ((i, j + 1), direction),
          grid,
        );
      }
    }

    if (direction == UP) {
      if (outOfBouds((i - 1, j), grid)) {
        return false;
      }
      if (grid[i - 1][j] == '#') {
        return isLoop(
          ((i, j), RIGHT),
          grid,
        );
      } else {
        return isLoop(
          ((i - 1, j), direction),
          grid,
        );
      }
    }

    if (direction == DOWN) {
      if (outOfBouds((i + 1, j), grid)) {
        return false;
      }
      if (grid[i + 1][j] == '#') {
        return isLoop(
          ((i, j), LEFT),
          grid,
        );
      } else {
        return isLoop(
          ((i + 1, j), direction),
          grid,
        );
      }
    }

    throw Exception("Das ist nicht gut!");
  }

  @override
  int solvePart1() {
    var grid = input.getCharacterGrid();
    GuardStance guard = getGuardStance(grid);
    fillGrid(guard, grid);

    int count = 0;

    grid.forEach((row) => row.forEach((c) {
          if (c == 'X') {
            count++;
          }
        }));
    return count;
  }

  @override
  int solvePart2() {
    var grid = input.getCharacterGrid();

    GuardStance guard = getGuardStance(grid);
    fillGrid(guard, grid);
    int counter = 0;

    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if ((i != guard.$1.$1 || j != guard.$1.$2) && grid[i][j] == 'X') {
          var before = grid[i][j];
          grid[i][j] = '#';
          positions = Set<(int, int, int)>();
          if (isLoop(guard, grid)) {
            counter++;
          }
          grid[i][j] = before;
        }
      }
    }
    return counter;
  }
}

extension matcher on List {
  int match(String x) {
    for (int i = 0; i < this.length; i++) {
      if (this[i] == x) {
        return i;
      }
    }
    return -1;
  }
}
