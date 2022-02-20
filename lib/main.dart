import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(213, 222, 240, 1),
        body: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              children: const [
                SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Center(
                  child: Text('You'),
                )),
                SizedBox(
                  width: 12,
                ),
                Expanded(child: Center(child: Text('Enemy')))
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Column(
                  children: const [
                    Center(
                      child: Text('1'),
                    ),
                    Center(
                      child: Text('1'),
                    ),
                    Center(
                      child: Text('1'),
                    ),
                    Center(
                      child: Text('1'),
                    ),
                    Center(
                      child: Text('1'),
                    ),
                  ],
                )),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Column(
                  children: const [
                    Center(
                      child: Text('1'),
                    ),
                    Center(
                      child: Text('1'),
                    ),
                    Center(
                      child: Text('1'),
                    ),
                    Center(
                      child: Text('1'),
                    ),
                    Center(
                      child: Text('1'),
                    ),
                  ],
                )),
              ],
            ),
            const Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text('Defened'.toUpperCase()),
                    const SizedBox(
                      height: 13,
                    ),
                    BodyPartButton(
                      bodyPart: BodyPart.head,
                      selected: defendingBodyPart == BodyPart.head,
                      bodyPartSetter: _selectDefendingBodyPart,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    BodyPartButton(
                      bodyPart: BodyPart.torso,
                      selected: defendingBodyPart == BodyPart.torso,
                      bodyPartSetter: _selectDefendingBodyPart,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    BodyPartButton(
                      bodyPart: BodyPart.legs,
                      selected: defendingBodyPart == BodyPart.legs,
                      bodyPartSetter: _selectDefendingBodyPart,
                    ),
                  ],
                )),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text('Attack'.toUpperCase()),
                    const SizedBox(
                      height: 13,
                    ),
                    BodyPartButton(
                      bodyPart: BodyPart.head,
                      selected: attackingBodyPart == BodyPart.head,
                      bodyPartSetter: _selectAttackingBodyPart,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    BodyPartButton(
                      bodyPart: BodyPart.torso,
                      selected: attackingBodyPart == BodyPart.torso,
                      bodyPartSetter: _selectAttackingBodyPart,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    BodyPartButton(
                      bodyPart: BodyPart.legs,
                      selected: attackingBodyPart == BodyPart.legs,
                      bodyPartSetter: _selectAttackingBodyPart,
                    ),
                  ],
                )),
                const SizedBox(width: 16)
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: (() => _onClickGo()),
                        child: SizedBox(
                          height: 40,
                          child: ColoredBox(
                            color: _checkActiveButton()
                                ? const Color.fromRGBO(0, 0, 0, 0.87)
                                : const Color.fromRGBO(0, 0, 0, 0.38),
                            child: Center(
                              child: Text('Go'.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: Colors.white)),
                            ),
                          ),
                        ))),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ));
  }

  void _selectDefendingBodyPart(final BodyPart value) {
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    setState(() {
      attackingBodyPart = value;
    });
  }

  void _onClickGo() {
    if (_checkActiveButton()) {
      setState(() {
        attackingBodyPart = null;
        defendingBodyPart = null;
      });
    }
  }

  bool _checkActiveButton() {
    return attackingBodyPart != null && defendingBodyPart != null;
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
                  ? const Color.fromRGBO(28, 121, 206, 1)
                  : const Color.fromRGBO(0, 0, 0, 0.38),
              child: Center(child: Text(bodyPart.name.toUpperCase())),
            )));
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
    return 'BodyPart{name: $name}';
  }
}
