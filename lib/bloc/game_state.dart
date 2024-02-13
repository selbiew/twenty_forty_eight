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

final class GameLost extends GameState {
  const GameLost(super.gameBoard);
}

final class GameWon extends GameState {
  const GameWon(super.gameBoard);
}

class GameBoard extends Equatable {
  // Row, column where 0,0 is the top left of the 4x4 grid.
  static const _coordinates = [
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
  static const _emptyGrid = [
    [null, null, null, null],
    [null, null, null, null],
    [null, null, null, null],
    [null, null, null, null]
  ];
  // We check the tiles in different directions based on the direction of the swipe.
  static const Map<Direction, List<(int, int)>> _tileMoveCheckOrders = {
    // Left to Right, Top to Bottom
    Direction.up: _coordinates,
    Direction.left: _coordinates,
    // Left to Right, Bottom to Top
    Direction.down: [
      (3, 0),
      (3, 1),
      (3, 2),
      (3, 3),
      (2, 0),
      (2, 1),
      (2, 2),
      (2, 3),
      (1, 0),
      (1, 1),
      (1, 2),
      (1, 3),
      (0, 0),
      (0, 1),
      (0, 2),
      (0, 3),
    ],
    // Right to Left, Top to Bottom
    Direction.right: [
      (0, 3),
      (0, 2),
      (0, 1),
      (0, 0),
      (1, 3),
      (1, 2),
      (1, 1),
      (1, 0),
      (2, 3),
      (2, 2),
      (2, 1),
      (2, 0),
      (3, 3),
      (3, 2),
      (3, 1),
      (3, 0)
    ],
  };

  static final _random = Random();

  const GameBoard(this.grid, this.score, this.isGameWon);
  const GameBoard.fresh()
      : grid = _emptyGrid,
        score = 0,
        isGameWon = false;

  final Grid<int?> grid;
  final int score;
  final bool isGameWon;

  @override
  List<Object?> get props => [grid];

  bool isGameLost() {
    return _coordinates
        .every((record) => !_hasMoves(record.$1, record.$2, grid));
  }

  bool _hasMoves(int row, int column, Grid<int?> grid) {
    int? currentValue = grid[row][column];
    if (currentValue != null) {
      return _adjacentCoordinates(row, column).any((record) =>
          grid[record.$1][record.$2] == null ||
          currentValue == grid[record.$1][record.$2]);
    }

    return false;
  }

  Set<(int, int)> _adjacentCoordinates(int row, int column) {
    return {
      (row - 1, column),
      (row, column - 1),
      (row, column + 1),
      (row + 1, column),
    }
        .where((record) =>
            0 <= record.$1 && record.$1 < 4 && 0 <= record.$2 && record.$2 < 4)
        .toSet();
  }

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
    bool isGameWon = false;
    List<(int, int)> tileMoveCheckOrder = _tileMoveCheckOrders[direction]!;
    for ((int, int) record in tileMoveCheckOrder) {
      int r = record.$1;
      int c = record.$2;
      while (_canMove(r, c, direction, newGrid)) {
        _swap(r, c, direction, newGrid);
        r = r + direction.y;
        c = c + direction.x;
      }

      if (_canMerge(r, c, direction, newGrid)) {
        if (newGrid[r][c]! == 1024) {
          isGameWon = true;
        }
        newScore += newGrid[r][c]! * 2;
        _merge(r, c, direction, newGrid);
      }
    }

    return GameBoard(newGrid, newScore, isGameWon);
  }

  GameBoard addTwo() {
    Grid<int?> newGrid = grid.copy();
    final emptyCoordinates =
        _coordinates.where((p) => newGrid[p.$1][p.$2] == null).toList();
    var selectedCoordinates =
        emptyCoordinates[_random.nextInt(emptyCoordinates.length)];
    newGrid[selectedCoordinates.$1][selectedCoordinates.$2] = 2;

    return GameBoard(newGrid, score, isGameWon);
  }

  GameBoard copy() {
    return GameBoard(grid.copy(), score, isGameWon);
  }
}
