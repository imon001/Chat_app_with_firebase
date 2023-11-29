import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SplashLoadingScreen extends StatelessWidget {
  const SplashLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          child: Center(
        child: SizedBox(
          height: 250,
          width: 200,
          child: LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [Theme.of(context).colorScheme.onBackground],
            strokeWidth: 2,
          ),
        ),
      )),
    );
  }
}
