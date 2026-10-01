import 'package:flutter/material.dart';

class PetDisplay extends StatelessWidget {
  final String petName;

  final int happiness;
  final int hunger;
  final int energy;

  final bool gameOver;
  final bool hasWon;

  final String? reaction;

  const PetDisplay({
    super.key,
    required this.petName,
    required this.happiness,
    required this.hunger,
    required this.energy,
    required this.gameOver,
    required this.hasWon,
    this.reaction,
  });

  String get moodLabel {
    if (happiness > 70) {
      return 'Happy';
    } else if (happiness >= 30) {
      return 'Neutral';
    } else {
      return 'Unhappy';
    }
  }

  Color get moodColor {
    if (happiness > 70) {
      return Colors.green;
    } else if (happiness >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  double get petScale {
    if (happiness > 70) {
      return 1.06;
    } else if (happiness < 30) {
      return 0.94;
    } else {
      return 1.0;
    }
  }

  String get petMessage {
    if (gameOver) {
      return 'I need a rest.';
    }

    if (hasWon) {
      return 'Best day ever!';
    }

    if (hunger > 80) {
      return "I'm starving!";
    }

    if (happiness <= 30) {
      return 'Play with me?';
    }

    if (energy < 20) {
      return 'So sleepy...';
    }

    return "Hi, I'm $petName!";
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.of(context).disableAnimations;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedScale(
              scale: petScale,
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(
                      milliseconds: 180,
                    ),
              curve: Curves.easeOutBack,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  moodColor,
                  BlendMode.modulate,
                ),
                child: Image.asset(
                  'assets/pet.png',
                  height: 170,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return const Icon(
                      Icons.pets,
                      size: 140,
                    );
                  },
                ),
              ),
            ),

            if (reaction != null)
              Positioned(
                top: 0,
                right: 20,
                child: AnimatedOpacity(
                  opacity: reaction == null
                      ? 0
                      : 1,
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(
                          milliseconds: 250,
                        ),
                  child: Text(
                    reaction!,
                    style: const TextStyle(
                      fontSize: 34,
                    ),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 14),

        Text(
          petName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        AnimatedSwitcher(
          duration: reduceMotion
              ? Duration.zero
              : const Duration(
                  milliseconds: 300,
                ),
          child: Text(
            petMessage,
            key: ValueKey(petMessage),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.circle,
              size: 14,
              color: moodColor,
            ),

            const SizedBox(width: 6),

            Text(
              'Mood: $moodLabel',
              style: const TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}