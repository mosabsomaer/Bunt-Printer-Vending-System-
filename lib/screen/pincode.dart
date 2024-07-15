import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:bunt_machine/helpers/consts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;
class PinCodeVerificationScreen extends StatefulWidget {
  final VoidCallback navigateto;

  const PinCodeVerificationScreen({required this.navigateto, super.key});

  @override
  State<PinCodeVerificationScreen> createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  FocusNode pinFocusNode = FocusNode();
  bool hasError = false;
  String errortext = "";
  String currentText = "";
  bool verifystats = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    pinFocusNode.addListener(() {
      if (!pinFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), () {
          FocusScope.of(context).requestFocus(pinFocusNode);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<File> fetchOrderData(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/downloadfile/$orderId'),headers: {
        'Authorization':'My9cdqbK0TPmdUkb2UpUK79Tkxr1Jf2RUluqjwWDT4jKt8uoxqplwCQ37SlUWNxHwORuZ9qQY1M4Ns5bHNXDNfCBK0D1TLJPbZj9dZ8dV7WJtIF2QApYWaIdO7vBzC8qhLccDkVaCK2ZCMtFAx5MtU6pmybQ8TnsBU5DpQzeah671360isoV5NccxaQz4szqDm1tOIpzV9dp1R58eKInWtuG7HTlebeqvTOhxNKOadTIXNmPw5jt775A5EYVfMXl5shdKAv9ipv3qRPPkI9c60JnoT1kscjpVkzdfzurMRKkHiJD013kOCjryatuylqgoo0vMozHN739rM6fKEcp4BIB06xkplL4ThO9tE4mlVNQZuhZWljyze1lyjKuscuYucmVhZCIsInByZXNldC53cml0ZSJdfQ.cGVM4LCJpYXQiOjE3MjAyMDIwOTIuOTcETdbGkhO0qj',
      } 
      );

      final prefs = await SharedPreferences.getInstance();
      
      if (response.statusCode == 200) {
        
        final contentDispositionHeader =
            response.headers['content-disposition'];
        final fileName = contentDispositionHeader
            ?.split(';')
            .firstWhere((element) => element.trim().startsWith('filename='))
            .substring('filename='.length)
            .replaceAll('"', '')
            .replaceAll('=', '');

        if (fileName == null) {
          throw Exception('Failed to get file name');
        }
final appDir = await getApplicationDocumentsDirectory();
final appPath = appDir.path;
final projectDir = path.join(appPath);
final file = File('$projectDir/$fileName');

await Directory(projectDir).create(recursive: true);

final mosab = double.parse(response.headers['total_price']!);
await prefs.setString('orderId', orderId);
await prefs.setDouble('totalPrice', mosab);
await file.writeAsBytes(response.bodyBytes);

return file;
      } else {
        final errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['error'];
        errortext = errorMessage;
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to fetch order data');
    }
  }

  Future<void> unzipAndStoreFile(File zipFile, String orderId) async {
    try {
      final bytes = zipFile.readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);

      final appDir = await getApplicationDocumentsDirectory();
      final orderDir = Directory('${appDir.path}/$orderId');
      if (!await orderDir.exists()) {
        await orderDir.create();
      }

      for (var file in archive) {
        final filename = file.name;
        final data = file.content as List<int>;
        File('${orderDir.path}/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }

      await zipFile.delete();
      debugPrint('Zip file unzipped and saved to: ${orderDir.path}');
    } catch (e) {
      debugPrint('Error unzipping file: $e');
      throw Exception('Failed to unzip file');
    }
  }

  void sendOrderRequest(String orderId) async {
    try {
      final zipFile = await fetchOrderData(orderId);
      await unzipAndStoreFile(zipFile, orderId);
      verifystats = true;
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

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
                            'Enter Order Code',
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
                              focusNode: pinFocusNode,
                              autoFocus: true,
                              appContext: context,
                              pastedTextStyle: const TextStyle(
                                color: Color.fromARGB(255, 191, 173, 105),
                                fontWeight: FontWeight.bold,
                              ),
                              length: 6,

                              animationType: AnimationType.scale,
                              validator: (v) {
                                if (v!.length == 6) {
                                  sendOrderRequest(currentText);

                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.circle,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 54,
                                  fieldWidth: 54,
                                  selectedColor:
                                      const Color.fromARGB(255, 191, 173, 105),
                                  activeColor:
                                      const Color.fromARGB(255, 191, 173, 105),
                                  activeFillColor: Colors.white,
                                  inactiveFillColor: Colors.white,
                                  selectedFillColor: Colors.white,
                                  inactiveColor:
                                      const Color.fromARGB(255, 191, 173, 105)),
                              cursorColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              enableActiveFill: true,
                              errorAnimationController: errorController,
                              controller: textEditingController,
                              keyboardType:TextInputType.number ,
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
                                if (!verifystats) {
                                  errorController!
                                      .add(ErrorAnimationType.shake);
                                  setState(() => hasError = true);
                                  FocusScope.of(context)
                                      .requestFocus(pinFocusNode);
                                } else {
                                  setState(() {
                                    hasError = false;
                                    snackBar("OTP Verified!!");
                                  });
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    widget.navigateto();
                                  });
                                }
                              },
                              // onTap: () {
                              //   print("Pressed");
                              // },
                              onChanged: (value) {
                                
                                setState(() {
                                  currentText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                               
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
                            hasError ? errortext : "",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        )
      ],
    );
  }
}
