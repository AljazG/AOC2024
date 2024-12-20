import '../model/advent_problem.dart';

class Day15 extends AdventProblem {
  Day15() : super(15);

  final int DOWN = 0;
  final int RIGHT = 1;
  final int UP = 2;
  final int LEFT = 3;

  final List<List<int>> directions = [
    [1, 0], // down
    [0, 1], // right
    [-1, 0], // up
    [0, -1] // left
  ];

  (List<List<String>>, String) parseInput(List<String> lines, bool p2) {
    List<List<String>> grid = [];
    String moves = "";
    bool readingGrid = true;
    for (String line in lines) {
      if (line == "") {
        readingGrid = false;
        continue;
      }
      if (readingGrid) {
        List<String> row = [];
        for (int i = 0; i < line.length; i++) {
          if (p2) {
            if (line[i] == '@') {
              row.add('@');
              row.add('.');
            }
            if (line[i] == '.') {
              row.add('.');
              row.add('.');
            }
            if (line[i] == 'O') {
              row.add('[');
              row.add(']');
            }
            if (line[i] == '#') {
              row.add('#');
              row.add('#');
            }
          } else {
            row.add(line[i]);
          }
        }
        grid.add(row);
      } else {
        moves += line;
      }
    }
    return (grid, moves);
  }

  (int, int) getPosition(List<List<String>> grid) {
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        if (grid[i][j] == '@') {
          return (i, j);
        }
      }
    }
    return (0, 0);
  }

  (int, int) makeMove(List<List<String>> grid, String move, int y, int x) {
    if (move == '>') {
      return moveInDir(grid, y, x, directions[RIGHT]);
    }

    if (move == '<') {
      return moveInDir(grid, y, x, directions[LEFT]);
    }

    if (move == '^') {
      return moveInDir(grid, y, x, directions[UP]);
    }

    if (move == 'v') {
      return moveInDir(grid, y, x, directions[DOWN]);
    }

    return (0, 0);
  }

  (int, int) moveInDir(
      List<List<String>> grid, int y, int x, List<int> dirVector) {
    int yNext = y + dirVector[0];
    int xNext = x + dirVector[1];

    if (grid[yNext][xNext] == '#') {
      return (y, x);
    }

    if (grid[yNext][xNext] == '.') {
      grid[y][x] = '.';
      grid[yNext][xNext] = '@';
      return (yNext, xNext);
    }

    if (grid[yNext][xNext] == 'O') {
      if (moveFish(grid, yNext, xNext, dirVector)) {
        grid[y][x] = '.';
        grid[yNext][xNext] = '@';
        return (yNext, xNext);
      }
      return (y, x);
    }

    if (grid[yNext][xNext] == '[' || grid[yNext][xNext] == ']') {
      if (directions[UP] == dirVector || directions[DOWN] == dirVector) {
        if (canMoveBoxVertical(grid, yNext, xNext, dirVector)) {
          moveBoxVertical(grid, yNext, xNext, dirVector);
          grid[y][x] = '.';
          grid[yNext][xNext] = '@';
          return (yNext, xNext);
        }
      } else {
        if (canMoveBox(grid, y, x, dirVector)) {
          moveBox(grid, y, x, dirVector);
          grid[y][x] = '.';
          grid[yNext][xNext] = '@';
          return (yNext, xNext);
        }
      }

      return (y, x);
    }

    return (0, 0);
  }

  bool canMoveBox(List<List<String>> grid, int y, int x, List<int> dirVector) {
    int yNext = y + dirVector[0];
    int xNext = x + dirVector[1];
    if (grid[yNext][xNext] == '#') {
      return false;
    }

    if (grid[yNext][xNext] == '.') {
      return true;
    }

    return canMoveBox(grid, yNext, xNext, dirVector);
  }

  bool canMoveBoxVertical(
      List<List<String>> grid, int y, int x, List<int> dirVector) {
    int yNext = y + dirVector[0];
    int xNext = x + dirVector[1];
    int x2, y2, yNext2, xNext2;

    if (grid[y][x] == '[') {
      x2 = x + 1;
      y2 = y;
    } else {
      x2 = x - 1;
      y2 = y;
    }

    yNext2 = y2 + dirVector[0];
    xNext2 = x2 + dirVector[1];

    if (grid[yNext][xNext] == '#' || grid[yNext2][xNext2] == '#') {
      return false;
    }

    if (grid[yNext][xNext] == '.' && grid[yNext2][xNext2] == '.') {
      return true;
    }

    bool move = true;
    bool move2 = true;
    bool move3 = true;

    if ((grid[yNext][xNext] == ']' || grid[yNext][xNext] == '[') &&
        grid[yNext][xNext] != grid[y][x]) {
      move = canMoveBoxVertical(grid, yNext, xNext, dirVector);
    }

    if ((grid[yNext2][xNext2] == ']' || grid[yNext2][xNext2] == '[') &&
        grid[yNext2][xNext2] != grid[y2][x2]) {
      move2 = canMoveBoxVertical(grid, yNext2, xNext2, dirVector);
    }

    if ((grid[yNext][xNext] != '.' && grid[yNext2][xNext2] != '.')) {
      move3 = canMoveBoxVertical(grid, yNext, xNext, dirVector);
    }

    return move && move2 && move3;
  }

  void moveBox(List<List<String>> grid, int y, int x, List<int> dirVector) {
    int yNext = y + dirVector[0];
    int xNext = x + dirVector[1];

    if (grid[yNext][xNext] == '.') {
      grid[yNext][xNext] = grid[y][x];
      return;
    }

    if (grid[yNext][xNext] == '#') {
      return;
    }

    moveBox(grid, yNext, xNext, dirVector);
    grid[yNext][xNext] = grid[y][x];
  }

  void moveBoxVertical(
      List<List<String>> grid, int y, int x, List<int> dirVector) {
    int yNext = y + dirVector[0];
    int xNext = x + dirVector[1];
    int x2, y2, yNext2, xNext2;

    if (grid[y][x] == '[') {
      x2 = x + 1;
      y2 = y;
    } else {
      x2 = x - 1;
      y2 = y;
    }

    yNext2 = y2 + dirVector[0];
    xNext2 = x2 + dirVector[1];

    if (grid[yNext][xNext] == '#' || grid[yNext2][xNext2] == '#') {
      return;
    }

    if (grid[yNext][xNext] == '.' && grid[yNext2][xNext2] == '.') {
      grid[yNext][xNext] = grid[y][x];
      grid[yNext2][xNext2] = grid[y2][x2];
      grid[y][x] = '.';
      grid[y2][x2] = '.';
      return;
    }

    if ((grid[yNext][xNext] == ']' || grid[yNext][xNext] == '[') &&
        grid[yNext][xNext] != grid[y][x]) {
      moveBoxVertical(grid, yNext, xNext, dirVector);
    }

    if ((grid[yNext2][xNext2] == ']' || grid[yNext2][xNext2] == '[') &&
        grid[yNext2][xNext2] != grid[y2][x2]) {
      moveBoxVertical(grid, yNext2, xNext2, dirVector);
    }

    if ((grid[yNext][xNext] != '.' && grid[yNext2][xNext2] != '.')) {
      moveBoxVertical(grid, yNext, xNext, dirVector);
    }

    grid[yNext][xNext] = grid[y][x];
    grid[yNext2][xNext2] = grid[y2][x2];
    grid[y][x] = '.';
    grid[y2][x2] = '.';
  }

  bool moveFish(List<List<String>> grid, int y, int x, List<int> dirVector) {
    int yNext = y + dirVector[0];
    int xNext = x + dirVector[1];

    if (grid[y][x] == '#') {
      return false;
    }

    if (grid[y][x] == '.') {
      return true;
    }

    bool move = moveFish(grid, yNext, xNext, dirVector);

    if (move) {
      grid[yNext][xNext] = 'O';
      grid[y][x] = '.';
    }

    return move;
  }

  int calcResult(List<List<String>> grid, bool p2) {
    int sum = 0;
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] == 'O' && !p2) {
          sum += (i * 100 + j);
        }

        if (grid[i][j] == '[' && p2) {
          sum += (i * 100 + j);
        }
      }
    }
    return sum;
  }

  @override
  int solvePart1() {
    List<String> lines = input.getList();
    var (grid, moves) = parseInput(lines, false);

    var (y, x) = getPosition(grid);

    for (int i = 0; i < moves.length; i++) {
      String move = moves[i];
      (y, x) = makeMove(grid, move, y, x);
    }

    return calcResult(grid, false);
  }

  @override
  int solvePart2() {
    List<String> lines = input.getList();
    var (grid, moves) = parseInput(lines, true);
    var (y, x) = getPosition(grid);
    for (int i = 0; i < moves.length; i++) {
      String move = moves[i];
      (y, x) = makeMove(grid, move, y, x);
    }
    return calcResult(grid, true);
  }
}
