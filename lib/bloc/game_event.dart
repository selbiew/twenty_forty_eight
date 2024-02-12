import 'package:twenty_forty_eight/bloc/game_state.dart';

sealed class GameEvent {
  const GameEvent();
}

final class GameStarted extends GameEvent {
  const GameStarted();
}

final class GameLost extends GameEvent {
  const GameLost();
}

final class Swiped extends GameEvent {
  const Swiped(this.direction);

  final Direction direction;
}
