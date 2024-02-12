import 'package:test/test.dart';
import 'package:twenty_forty_eight/bloc/game_state.dart';

void main() {
  // TODO: Add actual tests
  test('Two gamestates with different gameboards arent equal', () {
    const gb1 = GameBoard.fresh();
    const GameState gs1 = GameNew(gb1);
    gb1.addTwo();
    const GameState gs2 = GameNew(gb1);

    expect(gs1, gs2);
  });

  test('isGameOver returns true if the game is over', () {
    const gb1 = GameBoard([
      [2, 4, 8, 16],
      [4, 2, 16, 8],
      [8, 16, 2, 4],
      [16, 8, 4, 2]
    ], 0);
    return expect(gb1.isGameOver(), true);
  });
}
