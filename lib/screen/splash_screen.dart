import 'package:flutter/material.dart';
import 'package:simple_memo_final/constants/gaps.dart';
import 'package:simple_memo_final/constants/sizes.dart';
import 'package:simple_memo_final/screen/main_screen.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/";

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, MainScreen.routeName);
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          Sizes.size20,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/notepad.png",
                width: Sizes.size150 + Sizes.size30,
                height: Sizes.size150 + Sizes.size30,
              ),
              Gaps.v32,
              const Text(
                "Simple Memo",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Sizes.size40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
