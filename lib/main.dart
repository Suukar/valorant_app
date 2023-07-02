import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constant.dart';
import 'firebase_options.dart';
import 'homepage.dart';
import 'package:firebase_core/firebase_core.dart';

const TextStyle kDefaultTextStyle = TextStyle(
  fontFamily: 'Valorant',
  // Add other desired text style properties here
);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valorant Homepage',
      theme: ThemeData().copyWith(
          scaffoldBackgroundColor: kBackgroundcolor,
          textTheme: const TextTheme(
              bodyText2: kDefaultTextStyle, bodyText1: kDefaultTextStyle)),
      home: const Homepage(),
    );
  }
}
