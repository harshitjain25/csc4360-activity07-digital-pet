# In-Class Activity 07: Digital Pet

## Team Members

- **Harshit Jain**
- **Parsh Jadon**

## Project Overview

This project is a Flutter Digital Pet app created for In-Class Activity 07.

The app allows the user to care for a virtual pet by changing its name, feeding it, playing with it, letting it rest, and choosing activities. The pet's mood and appearance change based on its current state.

## Team Responsibilities

### Harshit Jain - Care Systems

Harshit worked mainly on the pet's core state and game logic:

- Pet name state
- Happiness, hunger, and energy meters
- Feed action
- Play action
- Rest action
- Reset behavior
- 30-second hunger timer
- Meter clamping between 0 and 100
- Win and game-over conditions
- Activity selection logic
- Core interaction testing

### Parsh Jadon - Pet Personality

Parsh worked mainly on the pet presentation and interaction feedback:

- Pet display widget
- Mood-based pet color
- Mood-based pet size
- Pet messages
- Animated mood/message changes
- Action reaction feedback
- Reduced-motion support
- Visual polish
- Interaction testing

## Graduate Pathway

We completed the graduate pathway.

### Advanced Features

1. **Energy System**
   - The pet has an energy meter.
   - Playing and running use energy.
   - Resting and sleeping restore energy.
   - Energy stays between 0 and 100.

2. **Activity Selection**
   - The user can select activities such as Run or Sleep.
   - Each activity changes the pet's state differently.

3. **Visual Polish and Accessible Motion**
   - The pet changes color based on mood.
   - The pet changes size based on happiness.
   - Animated messages are used for feedback.
   - Animated meter changes are used.
   - Action reactions are shown for care actions.
   - Reduced-motion settings are respected.

## Core App Behavior

The app includes the following required behavior:

- Editable pet name
- Happiness meter from 0 to 100
- Hunger meter from 0 to 100
- Energy meter from 0 to 100
- Readable mood label
- Mood color feedback
- Feed action
- Play action
- Rest action
- Reset action
- Hunger increases every 30 seconds
- Win condition when happiness stays above 80 continuously for 3 minutes
- Game over when hunger reaches 100 and happiness is 10 or lower
- Care actions are disabled after win or game over until reset

## Mood Rules

| Happiness | Mood | Pet Color | Pet Size |
|---|---|---|---|
| Below 30 | Unhappy | Red | Slightly smaller |
| 30 to 70 | Neutral | Yellow | Normal |
| Above 70 | Happy | Green | Slightly larger |

The app also shows a text mood label so color is not the only way the user receives mood feedback.

## Action Rules

### Feed

- Hunger decreases.
- Happiness changes depending on the resulting hunger level.
- Values stay between 0 and 100.

### Play

- Happiness increases.
- Hunger increases.
- Energy decreases.
- The action is blocked when the pet does not have enough energy.

### Rest

- Energy increases.
- Hunger increases slightly.

### Run

- Happiness increases.
- Hunger increases.
- Energy decreases.

### Sleep

- Energy increases.
- Hunger increases slightly.

### Reset

Reset restores the pet to its starting state:

- Happiness: 50
- Hunger: 50
- Energy: 70
- Game over: false
- Win: false
- Activity selection: Run

Reset also cancels the current win timer and restarts the hunger timer safely.

## Timer Behavior

The app uses lifecycle-aware timers.

### Hunger Timer

- Runs every 30 seconds.
- Hunger increases by 5.
- If hunger is already 100 and another hunger increase would occur, hunger remains at 100 and happiness decreases.
- The timer stops after a win or game over.

### Win Timer

- Starts when happiness becomes greater than 80.
- Happiness must remain above 80 continuously for 3 minutes.
- If happiness drops to 80 or below, the timer is canceled.
- A new timer starts if happiness later rises above 80 again.

All timers are canceled in `dispose()`.

## Architecture

The project separates the pet's presentation from the rest of the UI.

Parsh's pet display work is placed in:

```text
lib/widgets/pet_display.dart
```

The main application and state interactions are connected through:

```text
lib/main.dart
```

This keeps pet presentation code easier to manage and makes the visual behavior easier to update separately.

## Design Decision and Trade-Off

We used local Flutter state with `StatefulWidget` and `setState()` because this is a small single-screen application.

### Benefit

This approach keeps the project simple and makes state changes easy to understand.

### Trade-Off

As the application grows, keeping more logic inside the widget can become harder to test and maintain. A larger version of the app would benefit from moving all game rules into a separate model or service class.

## Pet Asset

The project uses:

```text
assets/pet.png
```

The pet image is tinted with `ColorFiltered` and `BlendMode.modulate`.

**Asset source/license:**  
Add the exact source and license for the image used in the final project here before submission.

Example:

```text
Source: [website or creator]
License: [license name]
```

## Project Structure

```text
digital_pet/
├── assets/
│   └── pet.png
├── lib/
│   ├── main.dart
│   └── widgets/
│       └── pet_display.dart
├── test/
├── pubspec.yaml
└── README.md
```

## How to Run

Make sure Flutter is installed and an Android device or emulator is available.

```bash
flutter pub get
flutter run
```

## Analyze the Project

```bash
flutter analyze
```

## Run Automated Tests

```bash
flutter test
```

## Build the Release APK

```bash
flutter clean
flutter pub get
flutter build apk --release
```

The APK is generated at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

For submission, rename it to:

```text
DigitalPet_Harshit_Parsh.apk
```

## Manual Testing

We tested the following behaviors:

| Test | Expected Result |
|---|---|
| Change pet name | New name appears in the app |
| Feed | Hunger decreases and related state updates |
| Play | Happiness increases, energy decreases, hunger increases |
| Rest | Energy increases |
| Run | Happiness increases and energy decreases |
| Sleep | Energy increases |
| Reset | Starting values are restored |
| Wait 30 seconds | Hunger increases by 5 |
| Happiness 29 | Unhappy, red, slightly smaller |
| Happiness 30 | Neutral, yellow |
| Happiness 70 | Neutral, yellow |
| Happiness 71 | Happy, green, slightly larger |
| Happiness above 80 for less than 3 minutes | No win |
| Happiness above 80 for 3 continuous minutes | Win |
| Happiness drops to 80 during win timer | Win timer is canceled |
| Hunger 100 and happiness 10 or lower | Game over |
| Meter boundary tests | Values stay between 0 and 100 |
| Reduced motion enabled | Nonessential animations are removed or shortened |

## Automated Test Evidence

All automated tests passed successfully.

```text
00:01 +16: All tests passed!
```

## GitHub Collaboration

### Branches

```text
harshit/care-systems
parsh/pet-personality
```

### Harshit Contribution

Harshit implemented the core care system and state logic.

Example commit:

```text
feat: implement digital pet core state and actions
```

### Parsh Contribution

Parsh implemented pet personality and visual feedback.

Example commit:

```text
feat: add pet personality and visual feedback
```

### Pull Requests

Add the final GitHub links here:

```text
Harshit PR:
[PASTE LINK]

Parsh PR:
[PASTE LINK]
```

### Review Evidence

Add the review links here:

```text
Parsh review of Harshit's work:
[PASTE LINK]

Harshit review of Parsh's work:
[PASTE LINK]
```

## Screenshots

Add screenshots of:

- Main app screen
- Happy mood
- Neutral mood
- Unhappy mood
- Feed/Play/Rest interaction
- Run/Sleep activity selection
- Portrait layout
- Landscape layout
- Test results

Suggested folder:

```text
docs/screenshots/
```

## Feature to Learning Outcome Map

| Feature | Learning Outcome | Evidence |
|---|---|---|
| Feed, Play, Rest, Reset | Use `setState()` to update visible state | Working controls and meter changes |
| Hunger Timer | Start and stop periodic work correctly | 30-second hunger change and timer cleanup |
| Energy System | Keep related state within valid limits | Energy meter and action tests |
| Activity Selection | Update multiple state values from one user action | Run and Sleep behavior |
| Mood Tint | Derive UI from the same pet state | Red, yellow, and green mood states |
| Mood Label | Provide accessible non-color feedback | Happy, Neutral, Unhappy text |
| Animated Pet | UI responds visually to state | Scale and message animations |
| Reduced Motion | Respect accessibility settings | Animation behavior with reduced motion enabled |
| Win/Loss Logic | Apply state rules consistently | Win and game-over tests |
| Reset | Restore a safe initial state | Reset test and timer restart |

## Final Submission

Each student submits the following separately in iCollege:

1. `github_link.txt`
2. `DigitalPet_Harshit_Parsh.apk`
3. Individual Critical Thinking Word document

For Harshit:

```text
HarshitJain_CriticalThinking.docx
```

For Parsh:

```text
ParshJadon_CriticalThinking.docx
```

## Final Checklist

- [ ] Complete Flutter source is pushed to GitHub
- [ ] Harshit contribution is visible in commit history
- [ ] Parsh contribution is visible in commit history
- [ ] Pull requests are linked
- [ ] Review evidence is linked
- [ ] Pet asset source/license is documented
- [ ] Screenshots are added
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes
- [ ] Release APK builds successfully
- [ ] Release APK installs and launches
- [ ] GitHub repository link works
- [ ] Each student submits their own reflection
