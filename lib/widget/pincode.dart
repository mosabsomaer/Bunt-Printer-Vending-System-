
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:bunt_machine/helpers/consts.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final VoidCallback navigateto;

  const PinCodeVerificationScreen({
    required this.navigateto,
    super.key,
  });

  @override
  State<PinCodeVerificationScreen> createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: primaryColor,
    body: GestureDetector(
     
      child: Center(
        child: SizedBox(
          width: 424,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const SizedBox(height: 38),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Enter Order Number',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: lowlightColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 30,
                  ),
                  child: PinCodeTextField(
                    autoFocus: true,
                    appContext: context,
                    pastedTextStyle: const TextStyle(
                      color: Color.fromARGB(255, 191, 173, 105),
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,

                    animationType: AnimationType.scale,
                    validator: (v) {
                      if (v!.length < 6) {
                        return "I'm from validator";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.circle,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 54,
                        fieldWidth: 54,
                        selectedColor: const Color.fromARGB(255, 191, 173, 105),
                        activeColor: const Color.fromARGB(255, 191, 173, 105),
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveColor:
                            const Color.fromARGB(255, 191, 173, 105)),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) {
                      debugPrint(v);
                      debugPrint("Completed");

                      currentText = v;
                      if (v != "123456") {
                        errorController!.add(ErrorAnimationType.shake);
                        setState(() => hasError = true);
                      } else {
                        setState(() {
                          hasError = false;
                          snackBar("OTP Verified!!");
                        });
                        widget.navigateto();
                      }
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              
              // Container(
              //   margin:
              //       const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
              //   child: ButtonTheme(
              //     height: 50,
              //     child: TextButton(
              //       onPressed: () {
              //         formKey.currentState!.validate();
              //         // conditions for validating
              //         if (currentText.length != 6 || currentText != "123456") {
              //           errorController!.add(ErrorAnimationType
              //               .shake); // Triggering error shake animation
              //           setState(() => hasError = true);
              //         } else {
              //           setState(
              //             () {
              //               hasError = false;
              //               snackBar("OTP Verified!!");
              //             },
              //           );
              //         }
              //       },
              //       child: Center(
              //         child: Text(
              //           "VERIFY".toUpperCase(),
              //           style: const TextStyle(
              //             color: Colors.white,
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              //   decoration: BoxDecoration(
              //       color: Colors.green.shade300,
              //       borderRadius: BorderRadius.circular(5),
              //       boxShadow: [
              //         BoxShadow(
              //             color: Colors.green.shade200,
              //             offset: const Offset(1, -2),
              //             blurRadius: 5),
              //         BoxShadow(
              //             color: Colors.green.shade200,
              //             offset: const Offset(-1, 2),
              //             blurRadius: 5)
              //       ]),
              // )
            ],
          ),
        ),
      ),
    ));
  }
}
