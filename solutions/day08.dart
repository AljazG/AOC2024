import 'dart:math';

import '../model/advent_problem.dart';

class Day08 extends AdventProblem {
  Day08() : super(8);

  Map<String, List<Point<int>>> getAntennaMap(List<List<String>> grid) {
    Map<String, List<Point<int>>> antennaMap = Map();
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] == '.') {
          continue;
        }
        List<Point<int>> points = [];

        if (antennaMap.containsKey(grid[i][j])) {
          points = antennaMap[grid[i][j]]!;
        }

        points.add(Point(i, j));

        antennaMap[grid[i][j]] = points;
      }
    }
    return antennaMap;
  }

  bool isPointInBounds(Point point, int maxX, int maxY) {
    return point.x >= 0 && point.x <= maxX && point.y >= 0 && point.y <= maxY;
  }

  List<Point<int>> calculateAntiNodes(Map<String, List<Point<int>>> antennaMap,
      List<List<String>> grid, bool part2) {
    int maxX = grid[0].length - 1;
    int maxY = grid.length - 1;

    Set<Point<int>> antiNodes = Set();

    for (List<Point<int>> sameAntennas in antennaMap.values) {
      for (int i = 0; i < sameAntennas.length; i++) {
        for (int j = i + 1; j < sameAntennas.length; j++) {
          Point<int> p1 = sameAntennas[i];
          Point<int> p2 = sameAntennas[j];

          int dx = p2.x - p1.x;
          int dy = p2.y - p1.y;

          Point<int> anti1 = Point(p1.x + 2 * dx, p1.y + 2 * dy);
          Point<int> anti2 = Point(p2.x - 2 * dx, p2.y - 2 * dy);

          if (isPointInBounds(anti1, maxX, maxY)) {
            antiNodes.add(anti1);
          }

          if (isPointInBounds(anti2, maxX, maxY)) {
            antiNodes.add(anti2);
          }

          if (!part2) {
            continue;
          }

          bool inBounds = true;
          Point<int> newAnti1 = p1;

          while (inBounds) {
            if (isPointInBounds(newAnti1, maxX, maxY)) {
              antiNodes.add(newAnti1);
              newAnti1 = Point(newAnti1.x + dx, newAnti1.y + dy);
            } else {
              inBounds = false;
            }
          }

          inBounds = true;
          Point<int> newAnti2 = p2;

          while (inBounds) {
            if (isPointInBounds(newAnti2, maxX, maxY)) {
              antiNodes.add(newAnti2);
              newAnti2 = Point(newAnti2.x - dx, newAnti2.y - dy);
            } else {
              inBounds = false;
            }
          }
        }
      }
    }

    return antiNodes.toList();
  }

  @override
  int solvePart1() {
    List<List<String>> grid = input.getCharacterGrid();
    Map<String, List<Point<int>>> antennaMap = getAntennaMap(grid);
    List<Point<int>> antiNodes = calculateAntiNodes(antennaMap, grid, false);
    return antiNodes.length;
  }

  @override
  int solvePart2() {
    List<List<String>> grid = input.getCharacterGrid();
    Map<String, List<Point<int>>> antennaMap = getAntennaMap(grid);
    List<Point<int>> antiNodes = calculateAntiNodes(antennaMap, grid, true);
    return antiNodes.length;
  }
}
