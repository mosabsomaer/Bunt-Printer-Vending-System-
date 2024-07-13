import 'dart:io';

import 'package:bunt_machine/helpers/consts.dart';
import 'package:bunt_machine/screen/pincode.dart';
import 'package:bunt_machine/screen/payscreen.dart';
import 'package:bunt_machine/screen/printscreen.dart';
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

Future<void> deleteAllContents() async {
  final directory = Directory('/Users/rodainaomaer/Library/Containers/com.example.buntMachine/Data/Documents');

  if (await directory.exists()) {
    try {
      final List<FileSystemEntity> entities = directory.listSync();
      for (FileSystemEntity entity in entities) {
        if (entity is File) {
          await entity.delete();
        } else if (entity is Directory) {
          await entity.delete(recursive: true);
        }
      }
      debugPrint('All contents deleted');
    } catch (e) {
      debugPrint('Error deleting contents: $e');
    }
  } else {
    debugPrint('Directory does not exist');
  }
}


  @override
  void initState()  {
    super.initState();

     deleteAllContents();

    screenWidgets = {
      Screen.pincode: PinCodeVerificationScreen(
        navigateto: () {
          setState(() {
            currentScreen = Screen.payscreen;
          });
        }
      ),
      Screen.payscreen: PayScreen(
        navigateto: () {
          setState(() {
            currentScreen = Screen.printscreen;
          });
        },exit:(){
           setState(() {
            currentScreen = Screen.pincode;
          });
        }
      ),
      Screen.printscreen: PrintScreen(
        navigateto: () {
          setState(() {
            currentScreen = Screen.pincode;
          });
        },exit:(){
           setState(() {
            currentScreen = Screen.pincode;
          });
        }
      ),
    };
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
                child:  getCurrentScreenWidget()),
          ),
        ],
      ),
    );
  }
}
//getCurrentScreenWidget()