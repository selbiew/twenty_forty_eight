import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/bloc/game_event.dart';
import 'package:twenty_forty_eight/bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(GameBoard gameBoard) : super(GameNew(gameBoard)) {
    on<GameStarted>(_onGameStarted);
    on<Swiped>(_onSwiped);
  }

  void _onGameStarted(GameStarted event, Emitter<GameState> emit) {
    emit(GameRunning(const GameBoard.fresh().addTwo()));
  }

  void _onSwiped(Swiped event, Emitter<GameState> emit) {
    GameBoard newBoard = state.gameBoard.swipe(event.direction);
    if (newBoard != state.gameBoard) {
      newBoard = newBoard.addTwo();
    }
    if (newBoard.isGameOver()) {
      emit(GameOver(newBoard));
    } else {
      emit(GameRunning(newBoard));
    }
  }
}
