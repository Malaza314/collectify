import 'dart:ui';
import 'package:collectify/Widgets/themedata.dart';
import 'package:collectify/init_packages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:ivoda/providers/app_data.dart';
// import 'package:ivoda/theme/theme_data.dart';
// import 'package:ivoda/widgets/utils.dart';
// import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;

  const LoadingOverlay({
    super.key, 
    required this.child, 
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: <Widget>[
        child, // Your main content
        if (appController.isLoading)
          Container(
            color: white.withOpacity(0.7), // Set the color to transparent
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 2.0,
                  sigmaY:
                      2.0), // Adjust the sigma values for the desired blur effect
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      "assets/loader.json",
                      width: 300, // Adjust the width as needed
                      height: 300, // Adjust the height as needed
                    ),
                    
                  ],
                ), // Network image as the loading indicator
              ),
            ),
          ),
      ],
    ));
  }
}