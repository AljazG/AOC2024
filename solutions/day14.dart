import '../model/advent_problem.dart';

class Robot {
  int x;
  int y;
  int xVelocity;
  int yVelocity;
  Robot(this.x, this.y, this.xVelocity, this.yVelocity);

  void move(int maxX, int maxY) {
    x += xVelocity;
    y += yVelocity;

    if (x >= maxX) {
      x = x - maxX;
    } else if (x < 0) {
      x = maxX + x;
    }

    if (y >= maxY) {
      y = y - maxY;
    } else if (y < 0) {
      y = maxY + y;
    }
  }
}

class Day14 extends AdventProblem {
  Day14() : super(14);

  List<Robot> parseInput(List<String> lines) {
    List<Robot> robots = [];
    for (String line in lines) {
      var split = line.split(" ");
      var positions = split[0].replaceAll("p=", "").split(",");
      var velocities = split[1].replaceAll("v=", "").split(",");
      int x = int.parse(positions[0]);
      int y = int.parse(positions[1]);
      int xVel = int.parse(velocities[0]);
      int yVel = int.parse(velocities[1]);
      robots.add(Robot(x, y, xVel, yVel));
    }
    return robots;
  }

  int getQuadrantFactor(List<Robot> robots, int maxX, int maxY) {
    int first = 0;
    int second = 0;
    int third = 0;
    int fourth = 0;

    int xDivide = (maxX / 2).floor();
    int yDivide = (maxY / 2).floor();

    for (Robot r in robots) {
      int x = r.x;
      int y = r.y;

      if (x < xDivide && y < yDivide) {
        first++;
      }
      if (x > xDivide && y < yDivide) {
        second++;
      }
      if (x < xDivide && y > yDivide) {
        third++;
      }
      if (x > xDivide && y > yDivide) {
        fourth++;
      }
    }

    return first * second * third * fourth;
  }

  bool isChristmasTree(List<List<int>> grid) {
    for (int i = 0; i < grid.length; i++) {
      int count = 0;
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] > 0) {
          count++;
        } else if (count > 0 || count > 10) {
          break;
        }
      }
      if (count > 10) {
        return true;
      }
    }
    return false;
  }

  @override
  int solvePart1() {
    List<String> lines = input.getList();

    var (maxX, maxY) = (101, 103);

    List<Robot> robots = parseInput(lines);

    for (int i = 0; i < 100; i++) {
      ;
      for (Robot robot in robots) {
        robot.move(maxX, maxY);
      }
    }

    return getQuadrantFactor(robots, maxX, maxY);
  }

  @override
  int solvePart2() {
    List<String> lines = input.getList();

    var (maxX, maxY) = (101, 103);

    List<List<int>> grid;

    List<Robot> robots = parseInput(lines);

    int seconds = 0;

    while (true) {
      seconds++;
      grid = List.generate(maxY, (_) => List.generate(maxX, (_) => 0));
      for (Robot robot in robots) {
        robot.move(maxX, maxY);
        grid[robot.y][robot.x]++;
      }
      if (isChristmasTree(grid)) {
        break;
      }
    }
    return seconds;
  }
}
