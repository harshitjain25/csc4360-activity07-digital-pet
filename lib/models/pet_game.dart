import 'dart:async';

class PetGame {
  String name;
  int happiness;
  int hunger;
  int energy;

  bool gameOver;
  bool hasWon;

  Timer? winTimer;

  final Duration winDuration;

  PetGame({
    this.name = 'Pip',
    this.happiness = 50,
    this.hunger = 50,
    this.energy = 70,
    this.gameOver = false,
    this.hasWon = false,
    this.winDuration = const Duration(minutes: 3),
  });

  int _clamp(int value) {
    return value.clamp(0, 100).toInt();
  }

  bool get canAct {
    return !gameOver && !hasWon;
  }

  void feed() {
    if (!canAct) return;

    final nextHunger = _clamp(hunger - 10);
    final happinessChange =
        nextHunger < 30 ? -20 : 10;

    hunger = nextHunger;
    happiness = _clamp(
      happiness + happinessChange,
    );

    checkLoss();
    updateWinTimer();
  }

  void play() {
    if (!canAct) return;

    if (energy < 10) {
      return;
    }

    happiness = _clamp(
      happiness + 15,
    );

    hunger = _clamp(
      hunger + 5,
    );

    energy = _clamp(
      energy - 10,
    );

    checkLoss();
    updateWinTimer();
  }

  void rest() {
    if (!canAct) return;

    energy = _clamp(
      energy + 20,
    );

    hunger = _clamp(
      hunger + 5,
    );

    checkLoss();
    updateWinTimer();
  }

  void runActivity() {
    if (!canAct) return;

    if (energy < 20) {
      return;
    }

    happiness = _clamp(
      happiness + 20,
    );

    hunger = _clamp(
      hunger + 10,
    );

    energy = _clamp(
      energy - 20,
    );

    checkLoss();
    updateWinTimer();
  }

  void sleepActivity() {
    if (!canAct) return;

    energy = _clamp(
      energy + 30,
    );

    hunger = _clamp(
      hunger + 5,
    );

    checkLoss();
    updateWinTimer();
  }

  void hungerTick() {
    if (!canAct) return;

    if (hunger + 5 > 100) {
      hunger = 100;

      happiness = _clamp(
        happiness - 20,
      );
    } else {
      hunger += 5;
    }

    checkLoss();
    updateWinTimer();
  }

  void checkLoss() {
    if (hunger == 100 &&
        happiness <= 10) {
      gameOver = true;

      winTimer?.cancel();
      winTimer = null;
    }
  }

  void updateWinTimer() {
    if (gameOver || hasWon) {
      return;
    }

    // Exactly 80 does not qualify.
    if (happiness <= 80) {
      winTimer?.cancel();
      winTimer = null;
      return;
    }

    winTimer ??= Timer(
      winDuration,
      () {
        winTimer = null;

        if (!gameOver &&
            happiness > 80) {
          hasWon = true;
        }
      },
    );
  }

  void reset() {
    winTimer?.cancel();
    winTimer = null;

    happiness = 50;
    hunger = 50;
    energy = 70;

    gameOver = false;
    hasWon = false;
  }

  void dispose() {
    winTimer?.cancel();
  }
}