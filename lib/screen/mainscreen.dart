import 'package:bunt_machine/helpers/consts.dart';
import 'package:bunt_machine/widget/pincode.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/Vector.png',
                      width: size.width * 0.1,
                      alignment: Alignment.center,
                    ),
                    Text(
                      'Bunt',
                      style: TextStyle(
                        fontSize: 96.0,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/download.png',
                  width: size.width * 0.24,
                ),
                const Text(
                  'Scan me or',
                  style: TextStyle(
                    fontSize: 36.0,
                  ),
                ),
                const Text(
                  'visit Bunt.com',
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: primaryColor,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height,
                    width: 424,
                    child: const PinCodeVerificationScreen(
                        // a random number, please don't call xD
                        ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
