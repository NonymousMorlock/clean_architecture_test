import 'package:clean_architecture_test/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_test/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:clean_architecture_test/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaBody extends StatefulWidget {
  const TriviaBody({super.key});

  @override
  State<TriviaBody> createState() => _TriviaBodyState();
}

class _TriviaBodyState extends State<TriviaBody> {
  final numberController = TextEditingController();

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (_, state) {
                    if (state is! Loading) {
                      if (state is Loaded) {
                        return TriviaDisplay(
                          trivia: state.trivia,
                        );
                      } else if (state is Error) {
                        return MessageDisplay(
                          message: state.message,
                        );
                      } else {
                        return MessageDisplay(
                          message: 'Start Searching',
                          height: cs.height / 3,
                        );
                      }
                    } else {
                      return const Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  width: isDesktop ? constraints.maxWidth * .3 : null,
                  child: TextField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      hintText: 'Input a number',
                    ),
                    onSubmitted: (_) => _getConcrete(),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _getConcrete,
                        child: const Text('Search'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                        ),
                        onPressed: _getRandom,
                        child: const Text('Get Random Trivia'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _getConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(numberController.text));
    numberController.clear();
  }

  void _getRandom() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(const GetTriviaForRandomNumber());
    numberController.clear();
  }
}
