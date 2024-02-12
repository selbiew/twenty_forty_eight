import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/bloc/game_bloc.dart';
import 'package:twenty_forty_eight/bloc/game_event.dart';
import 'package:twenty_forty_eight/bloc/game_state.dart';
import 'package:twenty_forty_eight/constants.dart';

class TwentyFortyEightHomePage extends StatelessWidget {
  const TwentyFortyEightHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameBloc(const GameBoard.fresh()),
      child: const GameView(),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScoreWidget(),
            TwentyFortyEightBoardView(),
            ActionsRow(),
          ],
        ),
      ),
    );
  }
}

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      return Center(
        child: Text(
          '${state.gameBoard.score}',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
      );
    });
  }
}

class TwentyFortyEightBoardView extends StatelessWidget {
  const TwentyFortyEightBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      List<Widget> children = [
        const Center(
          child: GameRunningView(),
        ),
      ];
      if (context.read<GameBloc>().state.runtimeType == GameOver) {
        children.add(const Center(child: GameOverView()));
      }
      return Stack(
        children: children,
      );
    });
  }
}

class TileGrid extends StatelessWidget {
  const TileGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: state.gameBoard.grid.map((r) => TileRow(r)).toList(),
      );
    });
  }
}

class TileRow extends StatelessWidget {
  const TileRow(this.row, {Key? key}) : super(key: key);

  final List<int?> row;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.map((e) => NumberTile(e)).toList(),
    );
  }
}

class NumberTile extends StatelessWidget {
  const NumberTile(this.value, {Key? key}) : super(key: key);

  final int? value;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: value != null ? 2 : 0,
      color: value != null ? Constants.tileColors[value] : null,
      child: SizedBox(
        height: 72,
        width: 72,
        child: Center(
          child: Text(
            '${value ?? ''}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ActionsRow extends StatelessWidget {
  const ActionsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            child: const Text('New Game'),
            onPressed: () => {
              context.read<GameBloc>().add(const GameStarted()),
            },
          ),
        ],
      ),
    );
  }
}

class GameOverView extends StatelessWidget {
  const GameOverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: Color.fromRGBO(50, 50, 0, 0.05),
          child: SizedBox(
            height: 348,
            width: 348,
            child: Center(
              child: Text(
                'You Lost!',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GameRunningView extends StatelessWidget {
  const GameRunningView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) => {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0.0)
          {
            context.read<GameBloc>().add(const SwipedRight()),
          }
        else if (details.primaryVelocity != null &&
            details.primaryVelocity! < 0.0)
          {
            context.read<GameBloc>().add(const SwipedLeft()),
          }
      },
      onVerticalDragEnd: (details) => {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0.0)
          {
            context.read<GameBloc>().add(const SwipedDown()),
          }
        else if (details.primaryVelocity != null &&
            details.primaryVelocity! < 0.0)
          {
            context.read<GameBloc>().add(const SwipedUp()),
          }
      },
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: SizedBox(
              height: 348,
              width: 348,
              child: TileGrid(),
            ),
          ),
        ],
      ),
    );
  }
}
