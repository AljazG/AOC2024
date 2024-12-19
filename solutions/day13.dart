import '../model/advent_problem.dart';

typedef Button = (int, int);
typedef Prize = (int, int);

class Contraption {
  Button a;
  Button b;
  Prize prize;
  Contraption(this.a, this.b, this.prize);
}

class Day13 extends AdventProblem {
  Day13() : super(13);

  List<Contraption> parseInput(List<String> lines, bool p2) {
    List<Contraption> contraptions = [];
    for (int i = 0; i < lines.length; i += 4) {
      String a = lines[i];
      String b = lines[i + 1];
      String prize = lines[i + 2];

      var aSplit = a.split(" ");
      var bSplit = b.split(" ");
      var prizeSplit = prize.split(" ");

      int prizeX = int.parse(prizeSplit[1].split('=')[1].replaceFirst(",", ""));
      int prizeY = int.parse(prizeSplit[2].split('=')[1]);

      if (p2) {
        prizeX += 10000000000000;
        prizeY += 10000000000000;
      }
      contraptions.add(Contraption((
        int.parse(aSplit[2].split('+')[1].replaceFirst(",", "")),
        int.parse(aSplit[3].split('+')[1])
      ), (
        int.parse(bSplit[2].split('+')[1].replaceFirst(",", "")),
        int.parse(bSplit[3].split('+')[1])
      ), (
        prizeX,
        prizeY
      )));
    }
    return contraptions;
  }

  (double, double) solve(Contraption contraption) {
    double xa = contraption.a.$1.toDouble();
    double ya = contraption.a.$2.toDouble();
    double xb = contraption.b.$1.toDouble();
    double yb = contraption.b.$2.toDouble();
    double xr = contraption.prize.$1.toDouble();
    double yr = contraption.prize.$2.toDouble();
    double bTimes = (xa * yr - ya * xr) / (yb * xa - xb * ya);
    double aTimes = (xr - xb * bTimes) / xa;
    return (aTimes, bTimes);
  }

  @override
  int solvePart1() {
    List<String> lines = input.getList();
    List<Contraption> contraptions = parseInput(lines, false);
    int sum = 0;
    for (Contraption contraption in contraptions) {
      double aTimes, bTimes;
      (aTimes, bTimes) = solve(contraption);
      if (aTimes.toInt() == aTimes && bTimes.toInt() == bTimes) {
        sum += (aTimes.toInt() * 3 + bTimes.toInt());
      }
    }
    return sum;
  }

  @override
  int solvePart2() {
    List<String> lines = input.getList();
    List<Contraption> contraptions = parseInput(lines, true);
    int sum = 0;
    for (Contraption contraption in contraptions) {
      double aTimes, bTimes;
      (aTimes, bTimes) = solve(contraption);
      if (aTimes.toInt() == aTimes && bTimes.toInt() == bTimes) {
        sum += (aTimes.toInt() * 3 + bTimes.toInt());
      }
    }
    return sum;
  }
}
