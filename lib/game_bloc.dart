import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/game_event.dart';
import 'package:twenty_forty_eight/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  static const GameBoard _board = GameBoard.fresh();

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
    emit(GameOver(_board.copy()));
  }

  void _onSwipedUp(SwipedUp event, Emitter<GameState> emit) {
    emit(GameRunning(_board.copy()));
  }

  void _onSwipedDown(SwipedDown event, Emitter<GameState> emit) {
    emit(GameRunning(_board.copy()));
  }

  void _onSwipedRight(SwipedRight event, Emitter<GameState> emit) {
    emit(GameRunning(_board.copy()));
  }

  void _onSwipedLeft(SwipedLeft event, Emitter<GameState> emit) {
    emit(GameRunning(_board.copy()));
  }
}
