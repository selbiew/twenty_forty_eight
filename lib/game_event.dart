sealed class GameEvent {}

final class GameStarted extends GameEvent {}

final class GameLost extends GameEvent {}

final class SwipedUp extends GameEvent {}

final class SwipedDown extends GameEvent {}

final class SwipedLeft extends GameEvent {}

final class SwipedRight extends GameEvent {}
