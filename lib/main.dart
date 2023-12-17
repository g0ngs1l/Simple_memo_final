import 'package:flutter/material.dart';
import 'package:simple_memo_final/data/memo_info.dart';
import 'package:simple_memo_final/screen/detail_screen.dart';
import 'package:simple_memo_final/screen/edit_screen.dart';
import 'package:simple_memo_final/screen/main_screen.dart';
import 'package:simple_memo_final/screen/splash_screen.dart';

void main() {
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIMPLE NOTE',
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: false,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        MainScreen.routeName: (context) => const MainScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        /// Edit Mode
        if (settings.name == EditScreen.routeName) {
          final MemoInfo? memo = settings.arguments as MemoInfo?;

          return MaterialPageRoute(
            builder: (BuildContext context) {
              return EditScreen(memo: memo);
            },
          );
        } else if (settings.name == DetailScreen.routeName) {
          /// View Mode
          final MemoInfo? memo = settings.arguments as MemoInfo?;

          return MaterialPageRoute(builder: (BuildContext context) {
            return DetailScreen(memo: memo);
          });
        }
        return null;
      },
    );
  }
}
