import 'dart:math';

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

List<int> turnBy90(List<int> direction) {
  int x = direction[0];
  int y = direction[1];
  return [y, -x];
}

List<int> turnBy180(List<int> direction) {
  int x = direction[0];
  int y = direction[1];
  return [-x, -y];
}

List<int> turnBy270(List<int> direction) {
  int x = direction[0];
  int y = direction[1];
  return [-y, x];
}

List<int> turnByAngle(List<int> direction, int angle) {
  double radAngle = (angle.toDouble() * pi) / 180;
  int x = direction[0];
  int y = direction[1];
  return [
    (x * cos(radAngle) - y * sin(radAngle)).round(),
    (x * sin(radAngle) + y * cos(radAngle)).round()
  ];
}

(int, int) applyDirection(int y, int x, List<int> dir) {
  return (y + dir[0], x + dir[1]);
}
