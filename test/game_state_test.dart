import 'package:test/test.dart';
import 'package:twenty_forty_eight/game_state.dart';

void main() {
  test('Two gamestates with different gameboards arent equal', () {
    final gb1 = GameBoard();
    final GameState gs1 = GameNew(gb1);
    gb1.addTwo();
    final GameState gs2 = GameNew(gb1);

    expect(gs1, gs2);
  });
}
