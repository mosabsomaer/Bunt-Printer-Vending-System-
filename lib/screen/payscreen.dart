import 'package:bunt_machine/helpers/consts.dart';
import 'package:flutter/material.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      SizedBox(
          height: size.height,
          width: 424,
          child: Scaffold(
              backgroundColor: primaryColor,
              body: Center(
                  child: SizedBox(
                      width: 424,
                      child: Column(children: [const SizedBox(height: 38),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'insert 3 dinar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              color: lowlightColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ), Text(
                            '0/3 Dinar inserted',
                            style: TextStyle(
                              
                              fontSize: 16,
                              color: coolblack,
                            ),
                            textAlign: TextAlign.center,
                          ),]
                        
                      ))))
    )]);
  }
}
