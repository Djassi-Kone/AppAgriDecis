import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 259,
      top: 38,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                AssetImage("assets/images/logo.png"),
          ),
          SizedBox(height: 10),
          Text(
            "AgriDecis",
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}