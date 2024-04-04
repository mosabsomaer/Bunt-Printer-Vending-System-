import 'package:bunt_machine/screen/payscreen.dart';
import 'package:bunt_machine/widget/pincode.dart';
import 'package:flutter/material.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  void movetoscreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PayScreen(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;
    return Column(
                
                children: [
                  SizedBox(
                    height: size.height,
                    width: 424,
                    child: PinCodeVerificationScreen(navigateto: movetoscreen),
                  )
                ],
              );
  }
}