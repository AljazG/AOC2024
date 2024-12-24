import 'dart:math';

import '../model/advent_problem.dart';
import '../utils/direction_utils.dart';
import '../utils/general_utils.dart';
import '../utils/grid_utils.dart';

typedef GridAndPositions = (List<List<String>>, (int, int), (int, int));

class Day16 extends AdventProblem {
  Day16() : super(16);

  List<List<String>> grid = [];
  List<List<int>> scores = [];

  GridAndPositions parseInput(List<String> lines) {
    (int, int) start = (0, 0);
    (int, int) end = (0, 0);
    grid = [];
    for (int i = 0; i < lines.length; i++) {
      List<String> row = [];
      for (int j = 0; j < lines[i].length; j++) {
        row.add(lines[i][j]);
        if (lines[i][j] == 'S') {
          start = (i, j);
        }
        if (lines[i][j] == 'E') {
          end = (i, j);
        }
      }
      grid.add(row);
    }
    return (grid, start, end);
  }

  int solveMaze(List<List<int>> visited, int i, int j, List<int> direction,
      int score, int minScore) {
    if (score > scores[i][j]) {
      return minScore;
    }

    if (grid[i][j] == 'E') {
      scores[i][j] = min(score, minScore);
      return min(score, minScore);
    }

    if (visited[i][j] > 0) {
      return minScore;
    }

    if (grid[i][j] == '#') {
      return minScore;
    }

    visited[i][j] = 1;
    scores[i][j] = score;

    // forward
    var (y, x) = applyDirection(i, j, direction);
    minScore = solveMaze(visited, y, x, direction, score + 1, minScore);

    // right
    var right = turnBy90(direction);
    (y, x) = applyDirection(i, j, right);
    minScore = solveMaze(visited, y, x, right, score + 1001, minScore);

    // behind
    var back = turnBy180(direction);
    (y, x) = applyDirection(i, j, back);
    minScore = solveMaze(visited, y, x, back, score + 2001, minScore);

    // left
    var left = turnBy270(direction);
    (y, x) = applyDirection(i, j, left);
    minScore = solveMaze(visited, y, x, left, score + 1001, minScore);
    visited[i][j] = 0;

    return minScore;
  }

  (int, int) minDistance(
      Map<(int, int), int> distances, Set<(int, int)> toExplore) {
    int min = MAX_INT;
    int iMin = 0;
    int jMin = 0;

    for (var p in toExplore) {
      int i = p.$1;
      int j = p.$2;
      if (distances[(i, j)]! <= min) {
        min = distances[(i, j)]!;
        iMin = i;
        jMin = j;
      }
    }

    return (iMin, jMin);
  }

  List<(int, int, int, List<int>)> getNeighbours(
      int i, int j, List<int> direction) {
    List<(int, int, int, List<int>)> neighbours = [];

    // forward
    var (y, x) = applyDirection(i, j, direction);

    if (grid[y][x] != '#') {
      neighbours.add((y, x, 1, direction));

      var (y2, x2) = applyDirection(y, x, direction);
      if (grid[y2][x2] != '#') {
        neighbours.add((y2, x2, 2, direction));
      }
    }

    // right
    var right = turnBy90(direction);
    (y, x) = applyDirection(i, j, right);

    if (grid[y][x] != '#') {
      neighbours.add((y, x, 1001, right));
    }

    // behind
    var back = turnBy180(direction);
    (y, x) = applyDirection(i, j, back);

    if (grid[y][x] != '#') {
      neighbours.add((y, x, 2001, back));
    }

    // left
    var left = turnBy270(direction);
    (y, x) = applyDirection(i, j, left);

    if (grid[y][x] != '#') {
      neighbours.add((y, x, 1001, left));
    }

    return neighbours;
  }

  Set<(int, int)> solveMazeP2(
      int iStart, int jStart, int iEnd, int jEnd, List<int> direction) {
    List<(int, int)> vertices = getVertices();
    Map<(int, int), int> distances = getDistances(vertices);
    Set<(int, int)> toExplore = Set();
    toExplore.add((iStart, jStart));

    Map<(int, int), List<int>> directions = Map();
    directions[(iStart, jStart)] = direction;

    Map<(int, int), Set<(int, int)>> paths = Map();

    paths[(iStart, jStart)] = Set<(int, int)>.of({(iStart, jStart)});

    while (!toExplore.isEmpty) {
      var (iV, jV) = minDistance(distances, toExplore);

      var direction = directions[(iV, jV)]!;
      Set<(int, int)> pathsToV = paths[(iV, jV)]!;

      toExplore.remove((iV, jV));

      var neighbours = getNeighbours(iV, jV, direction);

      for (var neigbour in neighbours) {
        int iN = neigbour.$1;
        int jN = neigbour.$2;
        int costN = neigbour.$3;
        List<int> dirN = neigbour.$4;

        int distFrom = distances[(iV, jV)]!;
        int distTo = distances[(iN, jN)]!;

        if (distFrom + costN < distTo) {
          distances[(iN, jN)] = distFrom + costN;
          directions[(iN, jN)] = dirN;
          scores[iN][jN] = distFrom + costN;
          toExplore.add((iN, jN));

          Set<(int, int)> pth = Set.from(pathsToV);
          pth.add((iN, jN));
          paths[(iN, jN)] = pth;
        } else if (distFrom + costN == distTo) {
          Set<(int, int)> pth = Set.from(pathsToV);
          pth = pth.union(paths[(iN, jN)]!);
          pth.add((iN, jN));
          paths[(iN, jN)] = pth;
        }
      }
    }
    return paths[(iEnd, jEnd)]!;
  }

  List<(int, int)> getVertices() {
    List<(int, int)> vertices = [];
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        if (grid[i][j] == '.' || grid[i][j] == 'E' || grid[i][j] == 'S') {
          vertices.add((i, j));
        }
      }
    }
    return vertices;
  }

  Map<(int, int), int> getDistances(List<(int, int)> vertices) {
    Map<(int, int), int> distances = Map();
    for (var (i, j) in vertices) {
      if (grid[i][j] == 'S') {
        distances[(i, j)] = 0;
        scores[i][j] = 0;
      } else {
        distances[(i, j)] = MAX_INT;
      }
    }
    return distances;
  }

  Map<(int, int), bool> getShortestPathSet(List<(int, int)> vertices) {
    Map<(int, int), bool> spSet = Map();
    for (var (i, j) in vertices) {
      spSet[(i, j)] = false;
    }
    return spSet;
  }

  @override
  int solvePart1() {
    var lines = input.getList();
    GridAndPositions gridAndPos = parseInput(lines);
    var grid = gridAndPos.$1;
    var start = gridAndPos.$2;

    List<List<int>> visited = List.generate(
      grid.length,
      (_) => List.filled(grid[0].length, 0),
    );

    scores = List.generate(
      grid.length,
      (_) => List.filled(grid[0].length, MAX_INT),
    );

    int result =
        solveMaze(visited, start.$1, start.$2, directions[RIGHT], 0, MAX_INT);

    return result;
  }

  @override
  int solvePart2() {
    var lines = input.getList();
    GridAndPositions gridAndPos = parseInput(lines);
    var grid = gridAndPos.$1;
    var start = gridAndPos.$2;
    var end = gridAndPos.$3;

    Set<(int, int)> validPositions =
        solveMazeP2(start.$1, start.$2, end.$1, end.$2, directions[RIGHT]);

    return validPositions.length;
  }
}
