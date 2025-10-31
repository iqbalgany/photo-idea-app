import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:photo_idea_app/common/app_constants.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  void gotoDashboard() {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              AppConstants.onboardingBackground,
              fit: BoxFit.cover,
              height: size.height,
            ).blurred(
              blurColor: Colors.black,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppConstants.onboarding,
                width: size.width * 0.8,
                height: size.height * 0.5,
              ),
              Gap(50),
              Text(
                'Welcome to Pidea',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              Gap(8),
              Text(
                'Explore your idea\nand  discover world class quality',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              Gap(24),
              OutlinedButton(
                onPressed: gotoDashboard,
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  side: WidgetStatePropertyAll(
                    BorderSide(color: Colors.white54),
                  ),
                ),
                child: Text('Begin'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
