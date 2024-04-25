import 'package:bunt_machine/helpers/consts.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PrintScreen extends StatefulWidget {
  final VoidCallback navigateto;

  const PrintScreen({super.key, required this.navigateto});

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  bool action = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height,
          width: 424,
          child: Scaffold(
            backgroundColor: primaryColor,
            body: Center(
              child: SizedBox(
                width: 424,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      action? 'Downloading Documents':'Printing \n 6 papers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: lowlightColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 82.0),
                      child: action
                          ? const SpinKitFadingCircle(
                              color: Colors.white,
                              size: 168.69,
                            )
                          : Stack(
                              children: [
                                Container(
                                  width: 168.69,
                                  height: 168.69,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: lowlightColor,
                                        size: 250 * 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          action = !action; // Toggle the value of 'action'
                        });
                      },
                      child: const SizedBox(height: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}