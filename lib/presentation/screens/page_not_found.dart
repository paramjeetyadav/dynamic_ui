import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../widgets/elevated_button.dart';

/// Page called for unknown route
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 200,
                height: 50,
                child: Center(
                  child: ElevatedButtonWidget(
                    title: "Home",
                    onPressed: () => context.go("/home"),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Gap(20)
            ],
          )),
    );
  }
}
