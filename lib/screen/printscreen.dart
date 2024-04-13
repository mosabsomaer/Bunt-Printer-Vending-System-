import 'package:bunt_machine/helpers/consts.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
class PrintScreen extends StatelessWidget {
  final VoidCallback navigateto;



  const PrintScreen({super.key, required this.navigateto});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      SizedBox(
          height: size.height,
          width: 424,
          child: Scaffold(
              backgroundColor: primaryColor,
              // ignore: prefer_const_constructors
              body: Center(
                  child: SizedBox(
                      width: 424,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Downloading Documents',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                  color: lowlightColor),
                              textAlign: TextAlign.center,
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 82.0),
                                child: SpinKitFadingCircle(
                                  color: Colors
                                      .white, 
                                  size:
                                      124.0, 
                                ))
                         , ]
                         
                         
                         
                         
                         )))))
    ]);
  }
  
}
