import 'package:bunt_machine/helpers/consts.dart';
import 'package:bunt_machine/screen/pincode.dart';
import 'package:bunt_machine/screen/payscreen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showPinCodeScreen = true;

  void moveToAddScreen() {
    setState(() {
      showPinCodeScreen = false;
    });
  }

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
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Vector.png',
                        width: size.width * 0.1,
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: showPinCodeScreen
                  ? PinCodeVerificationScreen(navigateto: moveToAddScreen)
                  : PayScreen(),
            ),
          ),
        ],
      ),
    );
  }
}