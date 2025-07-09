import 'dart:math';
import 'package:flutter/material.dart';
import 'package:number_guess/guess_app_bar.dart';
import 'package:number_guess/result_notice.dart';

class GuessPage extends StatefulWidget {
  const GuessPage({super.key});

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  int _value = 0;
  final Random _random = Random();
  bool _guessing = false;
  bool? _isBig;

  final TextEditingController _guessCtrl = TextEditingController();

  void _generateRandomValue() {
    setState(() {
      _guessing = true;
      _value = _random.nextInt(100);
      print(_value);
    });
  }

  void _onCheck() {
    print("====Check: $_value==== Target value: ${_guessCtrl.text}");

    int? guessValue = int.tryParse(_guessCtrl.text);

    // The game has not started, or the input is a non-integer, ignore
    if (!_guessing || guessValue == null) return;
    controller.forward(from: 0);
    // Guessed it right
    if (guessValue == _value) {
      setState(() {
        _isBig = null;
        _guessing = false;
      });
      return;
    }

    // Guessed wrong
    setState(() {
      _isBig = guessValue > _value;
    });
  }

  @override
  void dispose() {
    _guessCtrl.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GuessAppBar(onCheck: _onCheck, controller: _guessCtrl),
      body: Stack(
        children: [
          if (_isBig != null)
            Column(
              children: [
                if (_isBig!)
                  ResultNotice(
                    color: Colors.redAccent,
                    info: "Too Big",
                    controller: controller,
                  ),
                if (!_isBig!)
                  ResultNotice(
                    color: Colors.blueAccent,
                    info: "Too Small",
                    controller: controller,
                  ),
              ],
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_guessing) Text("Click to generate random value"),
                Text(
                  _guessing ? '**' : "$_value",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _guessing ? null : _generateRandomValue,
        backgroundColor: _guessing ? Colors.grey : Colors.blue,
        tooltip: 'Increment',
        child: Icon(Icons.generating_tokens_outlined),
      ),
    );
  }
}
