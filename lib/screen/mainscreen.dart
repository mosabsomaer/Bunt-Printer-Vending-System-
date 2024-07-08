import 'package:bunt_machine/helpers/consts.dart';
import 'package:bunt_machine/screen/pincode.dart';
import 'package:bunt_machine/screen/payscreen.dart';
import 'package:bunt_machine/screen/printscreen.dart';
import 'package:bunt_machine/screen/test2.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}
enum Screen {
  pincode,
  payscreen,
  printscreen,
  }
  
class _MainScreenState extends State<MainScreen> {
 Screen currentScreen = Screen.pincode;
  late Map<Screen, Widget> screenWidgets;

  @override
  void initState() {
    super.initState();

    screenWidgets = {
      Screen.pincode: PinCodeVerificationScreen(
        navigateto: () {
          moveToNextScreen(Screen.payscreen);
          setState(() {
            currentScreen = Screen.payscreen;
          });
        },
      ),
      Screen.payscreen: PayScreen(
        navigateto: () {
          moveToNextScreen(Screen.printscreen);
          setState(() {
            currentScreen = Screen.printscreen;
          });
        },
      ),
      Screen.printscreen: PrintScreen(
        navigateto: () {
          moveToNextScreen(Screen.pincode);
          setState(() {
            currentScreen = Screen.pincode;
          });
        },
      ),
    };
  }
  
void moveToNextScreen(Screen nextScreen) {
  setState(() {
    currentScreen = nextScreen;
    
  });
  
}

  Widget getCurrentScreenWidget() {
    return screenWidgets[currentScreen]!;
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
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const test2("345")),
          ),
        ],
      ),
    );
  }
}
