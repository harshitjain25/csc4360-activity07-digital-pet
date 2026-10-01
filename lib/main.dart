import 'dart:async';

import 'package:flutter/material.dart';

// In-Class Activity 07: Digital Pet
// Student: Harshit Jain
// Teammate: Parsh Jadon

void main() {
  runApp(const DigitalPetApp());
}

class DigitalPetApp extends StatelessWidget {
  const DigitalPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Pet',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DigitalPetPage(),
    );
  }
}

class DigitalPetPage extends StatefulWidget {
  const DigitalPetPage({super.key});

  @override
  State<DigitalPetPage> createState() => _DigitalPetPageState();
}

class _DigitalPetPageState extends State<DigitalPetPage> {
  String petName = 'Pip';

  int happiness = 50;
  int hunger = 50;
  int energy = 70;

  bool gameOver = false;
  bool hasWon = false;

  String selectedActivity = 'Run';

  final TextEditingController nameController =
      TextEditingController(text: 'Pip');

  Timer? hungerTimer;
  Timer? winTimer;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  int _clampMeter(int value) {
    return value.clamp(0, 100).toInt();
  }

  bool get _canAct => !gameOver && !hasWon;

  String get _moodLabel {
    if (happiness > 70) {
      return 'Happy';
    } else if (happiness >= 30) {
      return 'Neutral';
    } else {
      return 'Unhappy';
    }
  }

  Color get _moodColor {
    if (happiness > 70) {
      return Colors.green;
    } else if (happiness >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  double get _petScale {
    if (happiness > 70) {
      return 1.06;
    } else if (happiness < 30) {
      return 0.94;
    } else {
      return 1.0;
    }
  }

  String get _petMessage {
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

  void _startHungerTimer() {
    hungerTimer?.cancel();

    hungerTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (!mounted || !_canAct) {
          timer.cancel();
          return;
        }

        setState(() {
          if (hunger + 5 > 100) {
            hunger = 100;
            happiness = _clampMeter(happiness - 20);
          } else {
            hunger += 5;
          }
        });

        _updateOutcome();
      },
    );
  }

  void _saveName() {
    final newName = nameController.text.trim();

    if (newName.isEmpty) {
      _showMessage('Please enter a pet name.');
      return;
    }

    setState(() {
      petName = newName;
    });

    _showMessage('Pet name changed to $petName');
  }

  void _feedPet() {
    if (!_canAct) return;

    setState(() {
      final nextHunger = _clampMeter(hunger - 10);

      final happinessChange = nextHunger < 30 ? -20 : 10;

      hunger = nextHunger;
      happiness = _clampMeter(
        happiness + happinessChange,
      );
    });

    _showMessage('You fed $petName.');

    _updateOutcome();
  }

  void _playPet() {
    if (!_canAct) return;

    if (energy < 10) {
      _showMessage(
        '$petName is too tired to play.',
      );
      return;
    }

    setState(() {
      happiness = _clampMeter(
        happiness + 15,
      );

      hunger = _clampMeter(
        hunger + 5,
      );

      energy = _clampMeter(
        energy - 10,
      );
    });

    _showMessage(
      'You played with $petName.',
    );

    _updateOutcome();
  }

  void _restPet() {
    if (!_canAct) return;

    setState(() {
      energy = _clampMeter(
        energy + 20,
      );

      hunger = _clampMeter(
        hunger + 5,
      );
    });

    _showMessage(
      '$petName rested.',
    );

    _updateOutcome();
  }

  void _doSelectedActivity() {
    if (!_canAct) return;

    if (selectedActivity == 'Run') {
      if (energy < 20) {
        _showMessage(
          '$petName does not have enough energy to run.',
        );
        return;
      }

      setState(() {
        happiness = _clampMeter(
          happiness + 20,
        );

        hunger = _clampMeter(
          hunger + 10,
        );

        energy = _clampMeter(
          energy - 20,
        );
      });

      _showMessage(
        '$petName went for a run.',
      );
    } else {
      setState(() {
        energy = _clampMeter(
          energy + 30,
        );

        hunger = _clampMeter(
          hunger + 5,
        );
      });

      _showMessage(
        '$petName took a nap.',
      );
    }

    _updateOutcome();
  }

  void _updateOutcome() {
    if (gameOver || hasWon) {
      return;
    }

    if (hunger == 100 &&
        happiness <= 10) {
      winTimer?.cancel();
      winTimer = null;

      hungerTimer?.cancel();

      setState(() {
        gameOver = true;
      });

      return;
    }

    if (happiness <= 80) {
      winTimer?.cancel();
      winTimer = null;

      return;
    }

    winTimer ??= Timer(
      const Duration(minutes: 3),
      () {
        winTimer = null;

        if (!mounted ||
            gameOver ||
            happiness <= 80) {
          return;
        }

        setState(() {
          hasWon = true;
        });

        hungerTimer?.cancel();
      },
    );
  }

  void _resetPet() {
    winTimer?.cancel();
    winTimer = null;

    hungerTimer?.cancel();

    setState(() {
      happiness = 50;
      hunger = 50;
      energy = 70;

      gameOver = false;
      hasWon = false;

      selectedActivity = 'Run';
    });

    _startHungerTimer();

    _showMessage(
      'Game reset.',
    );
  }

  void _showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(
            seconds: 2,
          ),
        ),
      );
  }

  Widget _buildMeter({
    required String label,
    required int value,
    required bool reduceMotion,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $value',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 0,
            end: value / 100,
          ),
          duration: reduceMotion
              ? Duration.zero
              : const Duration(
                  milliseconds: 400,
                ),
          curve: Curves.easeOut,
          builder:
              (
                context,
                animatedValue,
                child,
              ) {
            return LinearProgressIndicator(
              value: animatedValue,
              minHeight: 10,
            );
          },
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final reduceMotion =
        MediaQuery.of(
          context,
        ).disableAnimations;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Digital Pet',
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            20,
          ),

          child: Column(
            children: [
              TextField(
                controller:
                    nameController,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Pet name',
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              FilledButton(
                onPressed:
                    _saveName,
                child:
                    const Text(
                  'Save Name',
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              AnimatedScale(
                scale:
                    _petScale,
                duration:
                    reduceMotion
                        ? Duration.zero
                        : const Duration(
                            milliseconds:
                                180,
                          ),
                curve:
                    Curves.easeOutBack,

                child:
                    ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(
                    _moodColor,
                    BlendMode
                        .modulate,
                  ),

                  child:
                      Image.asset(
                    'assets/pet.png',
                    height: 170,
                    fit:
                        BoxFit.contain,

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

              const SizedBox(
                height: 14,
              ),

              Text(
                petName,
                style:
                    const TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              AnimatedSwitcher(
                duration:
                    reduceMotion
                        ? Duration.zero
                        : const Duration(
                            milliseconds:
                                300,
                          ),

                child: Text(
                  _petMessage,
                  key: ValueKey(
                    _petMessage,
                  ),
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                'Mood: $_moodLabel',
                style:
                    const TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              _buildMeter(
                label:
                    'Happiness',
                value:
                    happiness,
                reduceMotion:
                    reduceMotion,
              ),

              _buildMeter(
                label:
                    'Hunger',
                value:
                    hunger,
                reduceMotion:
                    reduceMotion,
              ),

              _buildMeter(
                label:
                    'Energy',
                value:
                    energy,
                reduceMotion:
                    reduceMotion,
              ),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment:
                    WrapAlignment.center,

                children: [
                  FilledButton.icon(
                    onPressed:
                        _canAct
                            ? _feedPet
                            : null,
                    icon:
                        const Icon(
                      Icons.restaurant,
                    ),
                    label:
                        const Text(
                      'Feed',
                    ),
                  ),

                  FilledButton.icon(
                    onPressed:
                        _canAct
                            ? _playPet
                            : null,
                    icon:
                        const Icon(
                      Icons
                          .sports_esports,
                    ),
                    label:
                        const Text(
                      'Play',
                    ),
                  ),

                  FilledButton.icon(
                    onPressed:
                        _canAct
                            ? _restPet
                            : null,
                    icon:
                        const Icon(
                      Icons.bedtime,
                    ),
                    label:
                        const Text(
                      'Rest',
                    ),
                  ),

                  OutlinedButton.icon(
                    onPressed:
                        _resetPet,
                    icon:
                        const Icon(
                      Icons.restart_alt,
                    ),
                    label:
                        const Text(
                      'Reset',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),

              const Divider(),

              const SizedBox(
                height: 12,
              ),

              const Text(
                'Activity Selection',
                style:
                    TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              DropdownButton<String>(
                value:
                    selectedActivity,

                items:
                    const [
                  DropdownMenuItem(
                    value: 'Run',
                    child:
                        Text('Run'),
                  ),
                  DropdownMenuItem(
                    value: 'Sleep',
                    child:
                        Text('Sleep'),
                  ),
                ],

                onChanged:
                    _canAct
                        ? (value) {
                            if (value ==
                                null) {
                              return;
                            }

                            setState(() {
                              selectedActivity =
                                  value;
                            });
                          }
                        : null,
              ),

              const SizedBox(
                height: 8,
              ),

              FilledButton(
                onPressed:
                    _canAct
                        ? _doSelectedActivity
                        : null,
                child:
                    Text(
                  'Do $selectedActivity',
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              if (gameOver)
                const Text(
                  'GAME OVER',
                  style:
                      TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.red,
                  ),
                ),

              if (hasWon)
                const Text(
                  'YOU WON!',
                  style:
                      TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.green,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    winTimer?.cancel();
    nameController.dispose();

    super.dispose();
  }
}