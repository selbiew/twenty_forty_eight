import 'dart:math';

import 'package:equatable/equatable.dart';

enum Direction {
  // Because the top left is 0,0, the up and down directions are reversed.
  up(x: 0, y: -1),
  down(x: 0, y: 1),
  left(x: -1, y: 0),
  right(x: 1, y: 0);

  const Direction({required this.x, required this.y});

  final int x;
  final int y;
}

typedef Grid<T> = List<List<T>>;

extension GridExtensions on Grid {
  Grid<T> copy<T>() {
    return map((row) => List<T>.from(row)).toList();
  }
}

sealed class GameState extends Equatable {
  final GameBoard gameBoard;

  const GameState(this.gameBoard);

  @override
  List<Object> get props => [gameBoard];
}

final class GameNew extends GameState {
  const GameNew(super.gameBoard);
}

final class GameRunning extends GameState {
  const GameRunning(super.gameBoard);
}

final class GameOver extends GameState {
  const GameOver(super.gameBoard);
}

class GameBoard extends Equatable {
  // Row, column where 0,0 is the top left of the 4x4 grid.
  static const coordinates = [
    (0, 0),
    (0, 1),
    (0, 2),
    (0, 3),
    (1, 0),
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 0),
    (2, 1),
    (2, 2),
    (2, 3),
    (3, 0),
    (3, 1),
    (3, 2),
    (3, 3)
  ];
  static final _random = Random();
  static const emptyGrid = [
    [null, null, null, null],
    [null, null, null, null],
    [null, null, null, null],
    [null, null, null, null]
  ];

  const GameBoard(this.grid, this.score);
  const GameBoard.fresh()
      : grid = emptyGrid,
        score = 0;

  final Grid<int?> grid;
  final int score;

  @override
  List<Object?> get props => [grid];

  bool _canMerge(int row, int column, Direction direction, Grid<int?> grid) {
    if (grid[row][column] != null &&
        _isInBounds(row, column, direction, grid)) {
      int newRow = row + direction.y;
      int newColumn = column + direction.x;

      return grid[row][column] == grid[newRow][newColumn];
    }

    return false;
  }

  void _merge(int row, int column, Direction direction, Grid<int?> grid) {
    if (grid[row][column] != null &&
        _isInBounds(row, column, direction, grid) &&
        _canMerge(row, column, direction, grid)) {
      int newRow = row + direction.y;
      int newColumn = column + direction.x;

      grid[newRow][newColumn] = 2 * grid[row][column]!;
      grid[row][column] = null;
    }
  }

  bool _canMove(int row, int column, Direction direction, Grid<int?> grid) {
    if (grid[row][column] != null) {
      if (_isInBounds(row, column, direction, grid)) {
        int newRow = row + direction.y;
        int newColumn = column + direction.x;

        return grid[newRow][newColumn] == null;
      }
    }

    return false;
  }

  void _swap(int row, int column, Direction direction, Grid<int?> grid) {
    if (_isInBounds(row, column, direction, grid)) {
      int newRow = row + direction.y;
      int newColumn = column + direction.x;
      int? temp = grid[row][column];
      grid[row][column] = grid[newRow][newColumn];
      grid[newRow][newColumn] = temp;
    }
  }

  bool _isInBounds(int row, int column, Direction direction, Grid<int?> grid) {
    int newRow = row + direction.y;
    int newColumn = column + direction.x;

    return (newRow >= 0 && newRow <= 3) && (newColumn >= 0 && newColumn <= 3);
  }

  GameBoard swipe(Direction direction) {
    Grid<int?> newGrid = grid.copy();
    int newScore = score;
    switch (direction) {
      case Direction.left || Direction.up:
        for (int i = 0; i < 4; i++) {
          for (int j = 0; j < 4; j++) {
            int r = i;
            int c = j;
            while (_canMove(r, c, direction, newGrid)) {
              _swap(r, c, direction, newGrid);
              r = r + direction.y;
              c = c + direction.x;
            }

            if (_canMerge(r, c, direction, newGrid)) {
              newScore += newGrid[r][c]! * 2;
              _merge(r, c, direction, newGrid);
            }
          }
        }
        break;
      case Direction.down:
        for (int i = 3; i >= 0; i--) {
          for (int j = 0; j < 4; j++) {
            int r = i;
            int c = j;
            while (_canMove(r, c, direction, newGrid)) {
              _swap(r, c, direction, newGrid);
              r = r + direction.y;
              c = c + direction.x;
            }

            if (_canMerge(r, c, direction, newGrid)) {
              _merge(r, c, direction, newGrid);
            }
          }
        }
        break;
      case Direction.right:
        for (int i = 0; i < 4; i++) {
          for (int j = 3; j >= 0; j--) {
            int r = i;
            int c = j;
            while (_canMove(r, c, direction, newGrid)) {
              _swap(r, c, direction, newGrid);
              r = r + direction.y;
              c = c + direction.x;
            }

            if (_canMerge(r, c, direction, newGrid)) {
              _merge(r, c, direction, newGrid);
            }
          }
        }
        break;
    }

    return GameBoard(newGrid, newScore);
  }

  GameBoard addTwo() {
    Grid<int?> newGrid = grid.copy();
    final emptyCoordinates =
        coordinates.where((p) => newGrid[p.$1][p.$2] == null).toList();
    var selectedCoordinates =
        emptyCoordinates[_random.nextInt(emptyCoordinates.length)];
    newGrid[selectedCoordinates.$1][selectedCoordinates.$2] = 2;

    return GameBoard(newGrid, score);
  }

  GameBoard copy() {
    return GameBoard(grid.copy(), score);
  }
}
