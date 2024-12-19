import 'dart:math';

import '../model/advent_problem.dart';

class Day09 extends AdventProblem {
  Day09() : super(9);

  List<NumBlock> generateNumBlocks(String drive) {
    List<NumBlock> numBlocks = [];
    int id = 0;
    int free = 0;
    int size = 0;
    int blockIdx = 0;

    for (int i = 0; i < drive.length; i += 2) {
      if (i + 1 < drive.length) {
        free = int.parse(drive[i + 1]);
      }
      size = int.parse(drive[i]);
      numBlocks.add(NumBlock(id, blockIdx, size, free));
      blockIdx += (size + free);
      id++;
    }

    return numBlocks;
  }

  void fragment(List<NumBlock> numBlocks) {
    int freeSpaceIdx = 0;
    int blockToFragmentIdx = numBlocks.length - 1;

    while (blockToFragmentIdx > freeSpaceIdx) {
      if (numBlocks[freeSpaceIdx].freeSpace == 0) {
        freeSpaceIdx++;
        continue;
      }
      if (numBlocks[blockToFragmentIdx].blockSize == 0) {
        blockToFragmentIdx--;
        continue;
      }

      NumBlock toTake = numBlocks[blockToFragmentIdx];
      NumBlock toAdd = numBlocks[freeSpaceIdx];

      int toMove = min(toAdd.freeSpace, toTake.blockSize);
      int id = numBlocks[blockToFragmentIdx].fragment(toMove);
      numBlocks[freeSpaceIdx].addToFreeSpace(id, toMove);
    }
  }

  void fragmentP2(List<NumBlock> numBlocks) {
    int freeSpaceIdx;
    int blockToFragmentIdx = numBlocks.length - 1;

    while (blockToFragmentIdx > 0) {
      freeSpaceIdx = -1;
      for (int i = 0; i < blockToFragmentIdx; i++) {
        if (numBlocks[i].freeSpace >= numBlocks[blockToFragmentIdx].blockSize) {
          freeSpaceIdx = i;
          break;
        }
      }

      if (freeSpaceIdx == -1) {
        blockToFragmentIdx--;
        continue;
      }

      NumBlock toTake = numBlocks[blockToFragmentIdx];
      int toMove = toTake.blockSize;
      int id = numBlocks[blockToFragmentIdx].fragment(toMove);

      numBlocks[freeSpaceIdx].addToFreeSpace(id, toMove);

      blockToFragmentIdx--;
    }
  }

  @override
  int solvePart1() {
    String drive = input.getString();
    List<NumBlock> numBlocks = generateNumBlocks(drive);
    fragment(numBlocks);
    int sum = 0;
    numBlocks.forEach((n) => sum += n.getChecksum());
    return sum;
  }

  @override
  int solvePart2() {
    String drive = input.getString();
    List<NumBlock> numBlocks = generateNumBlocks(drive);
    fragmentP2(numBlocks);
    int sum = 0;
    numBlocks.forEach((n) => sum += n.getChecksum());
    return sum;
  }
}

class NumBlock {
  int id;
  int blockSize;
  int blockStart;
  int freeStart;

  int freeSpace;
  List<int> nums = [];
  NumBlock(this.id, this.blockStart, this.blockSize, this.freeSpace)
      : freeStart = blockStart + blockSize;

  int getChecksum() {
    int checksum = 0;

    for (int i = blockStart; i < blockStart + blockSize; i++) {
      checksum += id * i;
    }

    for (int i = freeStart; i < freeStart + nums.length; i++) {
      checksum += nums[i - freeStart] * i;
    }

    return checksum;
  }

  int fragment(int toFragment) {
    blockSize = blockSize - toFragment;
    freeSpace += toFragment;
    return id;
  }

  void addToFreeSpace(int id, int times) {
    for (int i = 0; i < times; i++) {
      nums.add(id);
    }
    freeSpace -= times;
  }
}
