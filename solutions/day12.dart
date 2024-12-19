import 'dart:math';

import '../model/advent_problem.dart';

typedef AreaAndPerimiter = (int, int);
typedef Vector = (int, int);
typedef fences = (int, int, int, int);

// TODO: rewrite using vectors for directions

class Day12 extends AdventProblem {
  Day12() : super(12);

  List<List<int>> constructGroupGrid(List<String> grid) {
    return List.generate(
        grid.length, (i) => List.generate(grid[i].length, (_) => 0));
  }

  void constructGroupToCost(Map<int, AreaAndPerimiter> groupToCost,
      List<String> grid, List<List<int>> groupGrid, bool p2) {
    int latestGroup = 0;

    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        latestGroup = addToGroup(i, j, grid, groupGrid, latestGroup);
        int fencesOrEdges = 0;
        if (!p2) {
          fencesOrEdges = countFences(i, j, groupGrid);
        } else {  
          fencesOrEdges = countEdges(i, j, groupGrid);
        }

        AreaAndPerimiter areaAndPerimiter;
        if (groupToCost.containsKey(groupGrid[i][j])) {
          areaAndPerimiter = groupToCost[groupGrid[i][j]]!;
        } else {
          areaAndPerimiter = (0, 0);
        }
        groupToCost[groupGrid[i][j]] = ( areaAndPerimiter.$1 + 1, areaAndPerimiter.$2 + fencesOrEdges);
      }
    }
  }

  int countFences(int i, int j, List<List<int>> grid) {
    int count = 0;
    if (outOfBoudsInt(i + 1, j, grid) || grid[i][j] !=  grid[i + 1][j]) {
      count++;
    }
    if (outOfBoudsInt(i - 1, j, grid) || grid[i][j] !=  grid[i - 1][j]) {
      count++;
    }
    if (outOfBoudsInt(i, j + 1, grid) || grid[i][j] !=  grid[i][j + 1]) {
      count++;
    }
    if (outOfBoudsInt(i, j - 1, grid) || grid[i][j] !=  grid[i][j - 1]) {
      count++;
    }
    return count;
  }

  int countEdges(int i, int j, List<List<int>> grid) {

    bool left = false;
    bool right = false;
    bool up = false;
    bool down = false;

    bool ur = false;
    bool ul = false;
    bool dr = false;
    bool dl = false;

    int count = 0;

    if (outOfBoudsInt(i + 1, j, grid) || grid[i][j] !=  grid[i + 1][j]) {
      down = true;
    }
    if (outOfBoudsInt(i - 1, j, grid) || grid[i][j] !=  grid[i - 1][j]) {
      up = true;
    }
    if (outOfBoudsInt(i, j + 1, grid) || grid[i][j] !=  grid[i][j + 1]) {
      right = true;
    }
    if (outOfBoudsInt(i, j - 1, grid) || grid[i][j] !=  grid[i][j - 1]) {
      left = true;
    }
    if (outOfBoudsInt(i - 1, j + 1, grid) || grid[i][j] !=  grid[i- 1][j + 1]) {
      ur= true;
    }
    if (outOfBoudsInt(i - 1, j - 1, grid) || grid[i][j] !=  grid[i - 1][j - 1]) {
      ul = true;
    }
    if (outOfBoudsInt(i + 1, j + 1, grid) || grid[i][j] !=  grid[i + 1][j + 1]) {
      dr = true;
    }
    if (outOfBoudsInt(i + 1, j - 1, grid) || grid[i][j] !=  grid[i + 1][j - 1]) {
      dl = true;
    }


    if (left && up) {
      count++;
    }

    if (!left && !up && ul) {
      count++;
    }

    if (up && right) {
      count++;
    }

    if (!up && !right && ur) {
      count++;
    }

    if (right && down) {
      count++;
    }

    if (!right && !down && dr) {
      count++;
    }

    if (down && left) {
      count++;
    }

    if (!down && !left && dl) {
      count++;
    }

    return count;
  }

  int addToGroup(int i, int j, List<String> grid, List<List<int>> groupGrid, int latestGroup) {
    if (groupGrid[i][j] != 0) {
      return latestGroup;
    }

    latestGroup++;

    dfs(i, j, i, j, grid, groupGrid, latestGroup);
 
    return latestGroup;
  }

  void dfs (int iFrom, int jFrom, int i, int j, List<String> grid, List<List<int>> groupGrid, int latestGroup) {
    if (outOfBouds(i, j, grid) || grid[i][j] != grid[iFrom][jFrom]) {
      return;
    }
  
    groupGrid[i][j] = latestGroup;
    if (!outOfBouds(i + 1, j, grid) && groupGrid[i + 1][j] == 0) {
      dfs(i, j, i + 1, j, grid, groupGrid, latestGroup);
    }
    if (!outOfBouds(i - 1, j, grid) && groupGrid[i - 1][j] == 0) {
          dfs(i, j, i - 1, j, grid, groupGrid, latestGroup);
    }
    if (!outOfBouds(i, j + 1, grid) && groupGrid[i][j + 1] == 0) {
       dfs(i, j, i, j + 1, grid, groupGrid, latestGroup);
    }
    if (!outOfBouds(i, j - 1, grid) && groupGrid[i][j - 1] == 0) {
          dfs(i, j, i, j - 1, grid, groupGrid, latestGroup);
    }
  }

  bool outOfBouds(int i, int j, List<String> grid) {
    return i < 0 || j < 0 || i >= grid.length || j >= grid[i].length;
  }

    bool outOfBoudsInt(int i, int j, List<List<int>> grid) {
    return i < 0 || j < 0 || i >= grid.length || j >= grid[i].length;
  }

  @override
  int solvePart1() {
    Map<int, AreaAndPerimiter> groupToCost = Map();
    List<String> grid = input.getList();
    List<List<int>> groupGrid = constructGroupGrid(grid);
    constructGroupToCost(groupToCost, grid, groupGrid, false);
    int sum = 0;


    groupToCost.values.forEach((areaAndPerimiter) {
      sum += (areaAndPerimiter.$1 * areaAndPerimiter.$2);
    });
    return sum;
  }

  @override
  int solvePart2() {
    Map<int, AreaAndPerimiter> groupToCost = Map();
    List<String> grid = input.getList();
    List<List<int>> groupGrid = constructGroupGrid(grid);
    constructGroupToCost(groupToCost, grid, groupGrid, true);
    int sum = 0;
    groupToCost.values.forEach((areaAndPerimiter) {
      sum += (areaAndPerimiter.$1 * areaAndPerimiter.$2);
    });
    return sum;
  }
}
