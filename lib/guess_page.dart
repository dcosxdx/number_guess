import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/guess/guess_bloc.dart';
import '/guess_app_bar.dart';
import '/result_notice.dart';

class GuessPage extends StatefulWidget {
  const GuessPage({super.key});

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final TextEditingController _guessCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _guessCtrl.dispose();
    controller.dispose();
    super.dispose();
  }

  void _onCheck(BuildContext context) {
    int? guessValue = int.tryParse(_guessCtrl.text);

    // The game has not started, or the input is a non-integer, ignore
    if (guessValue == null) return;
    controller.forward(from: 0);
    context.read<GuessBloc>().add(CheckGuess(guessValue));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GuessBloc(),
      child: BlocBuilder<GuessBloc, GuessState>(
        builder: (context, state) {
          bool guessing = false;
          bool? isBig;
          String valueText = '';
          if (state is GuessInitial) {
            guessing = false;
            valueText = '0';
          } else if (state is Guessing) {
            guessing = true;
            valueText = '**';
          } else if (state is GuessResult) {
            guessing = state.guessing;
            isBig = state.isBig;
            valueText = guessing ? '**' : '0';
          }

          return Scaffold(
            appBar: GuessAppBar(
              onCheck: () => _onCheck(context),
              controller: _guessCtrl,
            ),
            body: Stack(
              children: [
                if (isBig != null)
                  Column(
                    children: [
                      if (isBig)
                        ResultNotice(
                          color: Colors.redAccent,
                          info: "Too Big",
                          controller: controller,
                        ),
                      if (!isBig)
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
                      if (!guessing) Text("Click to generate random value"),
                      Text(
                        valueText,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed:
                  guessing
                      ? null
                      : () => context.read<GuessBloc>().add(GenerateRandom()),
              backgroundColor: guessing ? Colors.grey : Colors.blue,
              tooltip: 'Increment',
              child: Icon(Icons.generating_tokens_outlined),
            ),
          );
        },
      ),
    );
  }
}
