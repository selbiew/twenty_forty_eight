sealed class GameEvent {
  const GameEvent();
}

final class GameStarted extends GameEvent {
  const GameStarted();
}

final class GameLost extends GameEvent {
  const GameLost();
}

final class SwipedUp extends GameEvent {
  const SwipedUp();
}

final class SwipedDown extends GameEvent {
  const SwipedDown();
}

final class SwipedLeft extends GameEvent {
  const SwipedLeft();
}

final class SwipedRight extends GameEvent {
  const SwipedRight();
}
