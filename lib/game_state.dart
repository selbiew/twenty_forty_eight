import 'dart:math';

import 'package:equatable/equatable.dart';

typedef Grid<T> = List<List<T>>;

extension GridCopying on Grid {
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

  const GameBoard(this.grid);
  const GameBoard.fresh() : grid = emptyGrid;

  final Grid<int?> grid;

  @override
  List<Object?> get props => [grid];

  GameBoard addTwo() {
    Grid<int?> newGrid = grid.copy();
    final emptyCoordinates =
        coordinates.where((p) => newGrid[p.$1][p.$2] == null).toList();
    var selectedCoordinates =
        emptyCoordinates[_random.nextInt(emptyCoordinates.length)];
    newGrid[selectedCoordinates.$1][selectedCoordinates.$2] = 2;

    return GameBoard(newGrid);
  }

  GameBoard copy() {
    return GameBoard(grid.copy());
  }
}
