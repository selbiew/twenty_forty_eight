import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/bloc/game_event.dart';
import 'package:twenty_forty_eight/bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(GameBoard gameBoard) : super(GameNew(gameBoard)) {
    on<GameStarted>(_onGameStarted);
    on<GameLost>(_onGameLost);
    on<SwipedUp>(_onSwipedUp);
    on<SwipedDown>(_onSwipedDown);
    on<SwipedLeft>(_onSwipedLeft);
    on<SwipedRight>(_onSwipedRight);
  }

  void _onGameStarted(GameStarted event, Emitter<GameState> emit) {
    emit(GameRunning(const GameBoard.fresh().addTwo()));
  }

  void _onGameLost(GameLost event, Emitter<GameState> emit) {
    emit(GameOver(state.gameBoard));
  }

  void _onSwipedUp(SwipedUp event, Emitter<GameState> emit) {
    GameBoard newBoard = state.gameBoard.swipe(Direction.up);
    if (newBoard != state.gameBoard) {
      newBoard = newBoard.addTwo();
    }
    emit(GameRunning(newBoard));
  }

  void _onSwipedDown(SwipedDown event, Emitter<GameState> emit) {
    GameBoard newBoard = state.gameBoard.swipe(Direction.down);
    if (newBoard != state.gameBoard) {
      newBoard = newBoard.addTwo();
    }
    emit(GameRunning(newBoard));
  }

  void _onSwipedRight(SwipedRight event, Emitter<GameState> emit) {
    GameBoard newBoard = state.gameBoard.swipe(Direction.right);
    if (newBoard != state.gameBoard) {
      newBoard = newBoard.addTwo();
    }
    emit(GameRunning(newBoard));
  }

  void _onSwipedLeft(SwipedLeft event, Emitter<GameState> emit) {
    GameBoard newBoard = state.gameBoard.swipe(Direction.left);
    if (newBoard != state.gameBoard) {
      newBoard = newBoard.addTwo();
    }
    emit(GameRunning(newBoard));
  }
}
