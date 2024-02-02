import 'package:clean_architecture_test/features/number_trivia/presentation/views/number_trivia_screen.dart';
import 'package:clean_architecture_test/injection_container.dart' as di;
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        colorScheme: ColorScheme.light(
          secondary: Colors.green.shade600,
        ),
      ),
      home: const NumberTriviaScreen(),
    );
  }
}
