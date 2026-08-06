import 'package:flutter/material.dart';
class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 100,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Image.asset(
        'assets/images/star.png',
        width: 48,
        height: 48,
      color: Colors.white,
      );
  }
}