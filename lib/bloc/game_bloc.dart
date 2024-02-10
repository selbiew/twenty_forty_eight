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
    emit(GameRunning(state.gameBoard.swipe(Direction.up).addTwo()));
  }

  void _onSwipedDown(SwipedDown event, Emitter<GameState> emit) {
    emit(GameRunning(state.gameBoard.swipe(Direction.down).addTwo()));
  }

  void _onSwipedRight(SwipedRight event, Emitter<GameState> emit) {
    emit(GameRunning(state.gameBoard.swipe(Direction.right).addTwo()));
  }

  void _onSwipedLeft(SwipedLeft event, Emitter<GameState> emit) {
    emit(GameRunning(state.gameBoard.swipe(Direction.left).addTwo()));
  }
}