import 'package:clean_architecture_test/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_test/features/number_trivia/presentation/views/trivia_body.dart';
import 'package:clean_architecture_test/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaScreen extends StatelessWidget {
  const NumberTriviaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
        centerTitle: true,
      ),
      body: BlocProvider<NumberTriviaBloc>(
        create: (_) => sl<NumberTriviaBloc>(),
        child: const TriviaBody(),
      ),
    );
  }
}
