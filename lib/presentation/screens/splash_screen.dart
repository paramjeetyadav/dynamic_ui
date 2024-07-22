import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/infrastructure/utils/app_constants.dart';
import 'package:polaris/presentation/widgets/text_widget.dart';

import '../../infrastructure/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 4), () {
        context.goNamed(RouteName.home);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppConstants.assetLogo, width: double.maxFinite),
              const TextWidget(
                text: "POLARIS SMART METERING",
                size: 20,
                color: Color(0xFF1645a4),
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedTextKit(
                  repeatForever: false,
                  isRepeatingAnimation: false,
                  displayFullTextOnTap: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "We are on a mission to efficiently manage critical power infrastructures to change the way the world powers itself.",
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      speed: const Duration(milliseconds: 30),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
