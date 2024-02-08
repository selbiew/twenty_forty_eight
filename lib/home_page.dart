import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/game_bloc.dart';
import 'package:twenty_forty_eight/game_state.dart';

class TwentyFortyEightHomePage extends StatelessWidget {
  const TwentyFortyEightHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameBloc(GameBoard()),
      child: const GameView(),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TwentyFortyEightBoardView(),
      ),
    );
  }
}

class TwentyFortyEightBoardView extends StatelessWidget {
  const TwentyFortyEightBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameBoard gameBoard =
        context.select((GameBloc bloc) => bloc.state.gameBoard);

    return Card(
      child: Container(
        child: TileGrid(gameBoard.grid),
        height: 348,
        width: 348,
      ),
    );
  }
}

class TileGrid extends StatelessWidget {
  const TileGrid(this.grid, {Key? key}) : super(key: key);

  final List<List<int?>> grid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: grid.map((r) => TileRow(r)).toList(),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class TileRow extends StatelessWidget {
  const TileRow(this.row, {Key? key}) : super(key: key);

  final List<int?> row;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: row.map((e) => NumberTile(e)).toList(),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class NumberTile extends StatelessWidget {
  const NumberTile(this.value, {Key? key}) : super(key: key);

  final int? value;

  @override
  Widget build(BuildContext context) {
    return Card(
      // TODO: Color based on value
      child: SizedBox(
        height: 72,
        width: 72,
        child: Text('${value ?? ''}'),
      ),
    );
  }
}
