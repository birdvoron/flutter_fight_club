import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';
import 'package:flutter_fight_club/fight_club_icons.dart';
import 'package:flutter_fight_club/fight_club_images.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.pressStart2pTextTheme(
        Theme.of(context).textTheme,
      )),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const maxLives = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart? whatEnemyAtttacks = BodyPart.random();
  BodyPart? whatEnemyDefends = BodyPart.random();

  int yourLives = maxLives;
  int enemysLives = maxLives;

  String textInfo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
                maxLivesCount: maxLives,
                yourLivesCount: yourLives,
                enemysLivesCount: enemysLives),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: ColoredBox(
                    color: const Color.fromRGBO(197, 209, 234, 1),
                    child: Center(
                      child: Text(textInfo),
                    )),
              ),
            )),
            ControlsWidget(
                defendingBodyPart: defendingBodyPart,
                selectDefendingBodyPart: _selectDefendingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart),
            const SizedBox(
              height: 14,
            ),
            GoButton(
                text: yourLives == 0 || enemysLives == 0
                    ? 'Start new game'
                    : 'Go',
                onTap: _onGoButtonClicked,
                color: _getGoButtonColor()),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }

  void _selectDefendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }

  bool _checkActiveButton() {
    return attackingBodyPart != null && defendingBodyPart != null;
  }

  void _onGoButtonClicked() {
    if (yourLives == 0 || enemysLives == 0) {
      setState(() {
        yourLives = maxLives;
        enemysLives = maxLives;
        textInfo = '';
      });
    } else if (_checkActiveButton()) {
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAtttacks;
        if (enemyLoseLife) {
          enemysLives -= 1;
        }
        if (youLoseLife) {
          yourLives -= 1;
        }

        _getTextInfo();
        whatEnemyAtttacks = BodyPart.random();
        whatEnemyDefends = BodyPart.random();

        attackingBodyPart = null;
        defendingBodyPart = null;
      });
    }
  }

  Color _getGoButtonColor() {
    if (yourLives == 0 || enemysLives == 0) {
      return FightClubColors.greyButton;
    } else if (!_checkActiveButton()) {
      return FightClubColors.greyButton;
    } else {
      return FightClubColors.blackButton;
    }
  }

  _getTextInfo() {
    String text = '';

    if (yourLives == 0 && enemysLives == 0 && _checkActiveButton()) {
      text = 'Draw';
    }

    if (yourLives == 0 && enemysLives != 0 && _checkActiveButton()) {
      text = 'You lost';
    }
    if (yourLives != 0 && enemysLives == 0 && _checkActiveButton()) {
      text = 'You won';
    }

    if (yourLives != 0 && enemysLives != 0) {
      if (attackingBodyPart == whatEnemyDefends) {
        text = 'Your attack was blocked.';
      }
      if (attackingBodyPart != whatEnemyDefends) {
        text = 'You hit enemy’s ' +
            attackingBodyPart.toString().toLowerCase() +
            '.';
      }

      if (whatEnemyAtttacks == defendingBodyPart) {
        text += '\nEnemy’s attack was blocked.';
      }

      if (whatEnemyAtttacks != defendingBodyPart) {
        text += '\nEnemy hit your ' +
            whatEnemyAtttacks.toString().toLowerCase() +
            '.';
      }
    }

    setState(() {
      textInfo = text;
    });
  }
}

class GoButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const GoButton(
      {Key? key, required this.text, required this.onTap, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: ColoredBox(
              color: color,
              child: Center(
                child: Text(
                  text.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: FightClubColors.whiteText),
                ),
              )),
        ),
      ),
    );
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    Key? key,
    required this.bodyPart,
    required this.bodyPartSetter,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() => bodyPartSetter(bodyPart)),
        child: SizedBox(
            height: 40,
            child: ColoredBox(
              color: selected
                  ? FightClubColors.blueButton
                  : FightClubColors.greyButton,
              child: Center(
                  child: Text(bodyPart.name.toUpperCase(),
                      style: const TextStyle(
                          color: FightClubColors.darkGreyText))),
            )));
  }
}

class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemysLivesCount;

  const FightersInfo(
      {Key? key,
      required this.maxLivesCount,
      required this.yourLivesCount,
      required this.enemysLivesCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 160,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Expanded(child: ColoredBox(color: Colors.white)),
                Expanded(
                    child: ColoredBox(color: Color.fromRGBO(197, 209, 234, 1))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LivesWidget(
                    overallLivesCount: maxLivesCount,
                    currentLivesCount: yourLivesCount),
                Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    const Text('You',
                        style: TextStyle(color: FightClubColors.darkGreyText)),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: 92,
                      height: 92,
                      child: Image.asset(FightClubImages.youAvatar),
                    ),
                  ],
                ),
                const ColoredBox(
                    color: Colors.green,
                    child: SizedBox(
                      height: 44,
                      width: 44,
                    )),
                Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    const Text('Enemy',
                        style: TextStyle(color: FightClubColors.darkGreyText)),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: 92,
                      height: 92,
                      child: Image.asset(FightClubImages.enemyAvatar),
                    ),
                  ],
                ),
                LivesWidget(
                    overallLivesCount: maxLivesCount,
                    currentLivesCount: enemysLivesCount)
              ],
            )
          ],
        ));
  }
}

class ControlsWidget extends StatelessWidget {
  final BodyPart? defendingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;

  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  const ControlsWidget(
      {Key? key,
      required this.defendingBodyPart,
      required this.selectDefendingBodyPart,
      required this.attackingBodyPart,
      required this.selectAttackingBodyPart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        Expanded(
            child: Column(
          children: [
            Text("Defend".toUpperCase(),
                style: const TextStyle(color: FightClubColors.darkGreyText)),
            const SizedBox(
              height: 13,
            ),
            BodyPartButton(
                bodyPart: BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart,
                selected: defendingBodyPart == BodyPart.head),
            const SizedBox(
              height: 14,
            ),
            BodyPartButton(
                bodyPart: BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart,
                selected: defendingBodyPart == BodyPart.torso),
            const SizedBox(
              height: 14,
            ),
            BodyPartButton(
                bodyPart: BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart,
                selected: defendingBodyPart == BodyPart.legs),
          ],
        )),
        const SizedBox(width: 12),
        Expanded(
            child: Column(
          children: [
            Text('Attack'.toUpperCase(),
                style: const TextStyle(color: FightClubColors.darkGreyText)),
            const SizedBox(
              height: 13,
            ),
            BodyPartButton(
                bodyPart: BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,
                selected: attackingBodyPart == BodyPart.head),
            const SizedBox(
              height: 14,
            ),
            BodyPartButton(
                bodyPart: BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,
                selected: attackingBodyPart == BodyPart.torso),
            const SizedBox(
              height: 14,
            ),
            BodyPartButton(
                bodyPart: BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,
                selected: attackingBodyPart == BodyPart.legs),
          ],
        )),
        const SizedBox(
          width: 16,
        )
      ],
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget({
    Key? key,
    required this.overallLivesCount,
    required this.currentLivesCount,
  })  : assert(overallLivesCount > -1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(overallLivesCount, (index) {
        if (index < currentLivesCount) {
          return Image.asset(
            FightClubIcons.heartFull,
            width: 18,
            height: 18,
          );
        } else {
          return Image.asset(
            FightClubIcons.heartEmpty,
            width: 18,
            height: 18,
          );
        }
      }),
    );
  }
}

class BodyPart {
  final String name;
  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    // return 'BodyPart{name: $name}';
    return name;
  }

  static const List<BodyPart> _values = [head, torso, legs];
  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}
