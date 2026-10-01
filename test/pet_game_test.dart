import 'package:flutter_test/flutter_test.dart';
import 'package:digital_pet/models/pet_game.dart';

void main() {
  group('PetGame tests', () {
    test('initial values are correct', () {
      final game = PetGame();

      expect(game.name, 'Pip');
      expect(game.happiness, 50);
      expect(game.hunger, 50);
      expect(game.energy, 70);
      expect(game.gameOver, false);
      expect(game.hasWon, false);

      game.dispose();
    });

    test('feed decreases hunger', () {
      final game = PetGame(
        happiness: 50,
        hunger: 50,
      );

      game.feed();

      expect(game.hunger, 40);
      expect(game.happiness, 60);

      game.dispose();
    });

    test(
      'feed can reduce happiness when resulting hunger is below 30',
      () {
        final game = PetGame(
          happiness: 50,
          hunger: 20,
        );

        game.feed();

        expect(game.hunger, 10);
        expect(game.happiness, 30);

        game.dispose();
      },
    );

    test('play changes all related meters', () {
      final game = PetGame(
        happiness: 50,
        hunger: 50,
        energy: 70,
      );

      game.play();

      expect(game.happiness, 65);
      expect(game.hunger, 55);
      expect(game.energy, 60);

      game.dispose();
    });

    test(
      'play does nothing when energy is below 10',
      () {
        final game = PetGame(
          happiness: 50,
          hunger: 50,
          energy: 5,
        );

        game.play();

        expect(game.happiness, 50);
        expect(game.hunger, 50);
        expect(game.energy, 5);

        game.dispose();
      },
    );

    test('rest increases energy', () {
      final game = PetGame(
        energy: 70,
        hunger: 50,
      );

      game.rest();

      expect(game.energy, 90);
      expect(game.hunger, 55);

      game.dispose();
    });

    test('values do not go above 100', () {
      final game = PetGame(
        happiness: 95,
        hunger: 95,
        energy: 95,
      );

      game.rest();

      expect(game.energy, 100);
      expect(game.hunger, 100);

      game.dispose();
    });

    test('values do not go below 0', () {
      final game = PetGame(
        happiness: 5,
        hunger: 5,
        energy: 5,
      );

      game.feed();

      expect(game.hunger, 0);
      expect(game.happiness, 0);

      game.dispose();
    });

    test(
      'hunger 95 becomes 100 without happiness penalty',
      () {
        final game = PetGame(
          happiness: 50,
          hunger: 95,
        );

        game.hungerTick();

        expect(game.hunger, 100);
        expect(game.happiness, 50);

        game.dispose();
      },
    );

    test(
      'next hunger tick at 100 reduces happiness by 20',
      () {
        final game = PetGame(
          happiness: 50,
          hunger: 100,
        );

        game.hungerTick();

        expect(game.hunger, 100);
        expect(game.happiness, 30);

        game.dispose();
      },
    );

    test(
      'game over occurs at hunger 100 and happiness 10',
      () {
        final game = PetGame(
          hunger: 100,
          happiness: 10,
        );

        game.checkLoss();

        expect(game.gameOver, true);
        expect(game.canAct, false);

        game.dispose();
      },
    );

    test(
      'exactly 80 happiness does not start win timer',
      () {
        final game = PetGame(
          happiness: 80,
        );

        game.updateWinTimer();

        expect(game.winTimer, null);
        expect(game.hasWon, false);

        game.dispose();
      },
    );

    test(
      'happiness above 80 starts win timer',
      () {
        final game = PetGame(
          happiness: 81,
        );

        game.updateWinTimer();

        expect(game.winTimer, isNotNull);

        game.dispose();
      },
    );

    test(
      'dropping to 80 cancels win timer',
      () {
        final game = PetGame(
          happiness: 81,
        );

        game.updateWinTimer();

        expect(game.winTimer, isNotNull);

        game.happiness = 80;
        game.updateWinTimer();

        expect(game.winTimer, null);
        expect(game.hasWon, false);

        game.dispose();
      },
    );

    test(
      'pet wins after staying above 80 for required duration',
      () async {
        final game = PetGame(
          happiness: 81,

          // Short duration used only for automated testing.
          winDuration:
              const Duration(milliseconds: 50),
        );

        game.updateWinTimer();

        await Future.delayed(
          const Duration(milliseconds: 100),
        );

        expect(game.hasWon, true);

        game.dispose();
      },
    );

    test(
      'reset restores starting values',
      () {
        final game = PetGame(
          happiness: 90,
          hunger: 90,
          energy: 10,
          gameOver: true,
        );

        game.reset();

        expect(game.happiness, 50);
        expect(game.hunger, 50);
        expect(game.energy, 70);
        expect(game.gameOver, false);
        expect(game.hasWon, false);
        expect(game.winTimer, null);

        game.dispose();
      },
    );
  });
}