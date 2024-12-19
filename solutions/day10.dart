import 'dart:math';

import '../model/advent_problem.dart';

class Day10 extends AdventProblem {
  Day10() : super(10);

  final int START = 0;
  final int RIGHT = 1;
  final int LEFT = 2;
  final int UP = 3;
  final int DOWN = 4;

  List<Point> getStartingPositions(List<List<int>> grid) {
    List<Point> pts = [];
    for (final (i, row) in grid.indexed) {
      for (final (j, el) in row.indexed) {
        if (el == 0) {
          pts.add(Point(i, j));
        }
      }
    }
    return pts;
  }

  int getScore(
      List<List<int>> grid, int i, int j, int from, Set<Point> visited) {
    if (i < 0 || i == grid.length || j < 0 || j == grid[0].length) {
      return 0;
    }
    if (from == LEFT && grid[i][j] != grid[i][j - 1] + 1) {
      return 0;
    }
    if (from == RIGHT && grid[i][j] != grid[i][j + 1] + 1) {
      return 0;
    }
    if (from == UP && grid[i][j] != grid[i - 1][j] + 1) {
      return 0;
    }
    if (from == DOWN && grid[i][j] != grid[i + 1][j] + 1) {
      return 0;
    }

    if (grid[i][j] == 9) {
      visited.add(Point(i, j));
      return 1;
    }

    int right = getScore(grid, i, j + 1, LEFT, visited);
    int left = getScore(grid, i, j - 1, RIGHT, visited);
    int down = getScore(grid, i + 1, j, UP, visited);
    int up = getScore(grid, i - 1, j, DOWN, visited);

    return right + left + up + down;
  }

  @override
  int solvePart1() {
    List<List<int>> grid = input.getIntGridByPattern('');
    List<Point> startingPoints = getStartingPositions(grid);
    int sum = 0;
    for (Point p in startingPoints) {
      Set<Point> visited = Set();
      getScore(grid, p.x.toInt(), p.y.toInt(), 0, visited);
      sum += visited.length;
    }
    return sum;
  }

  @override
  int solvePart2() {
    List<List<int>> grid = input.getIntGridByPattern('');
    List<Point> startingPoints = getStartingPositions(grid);
    int sum = 0;
    for (Point p in startingPoints) {
      Set<Point> visited = Set();
      sum += getScore(grid, p.x.toInt(), p.y.toInt(), 0, visited);
    }
    return sum;
  }
}
