import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/game_event.dart';
import 'package:twenty_forty_eight/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  static GameBoard _board = GameBoard();

  GameBloc(GameBoard gameBoard) : super(GameNew(gameBoard)) {
    on<GameStarted>(_onGameStarted);
  }

  void _onGameStarted(GameStarted event, Emitter<GameState> emit) {
    _board.addTwo();
    emit(GameRunning(_board));
  }
}
