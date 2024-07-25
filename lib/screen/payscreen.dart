import 'dart:async';
import 'dart:io';

import 'package:bunt_machine/helpers/consts.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PayScreen extends StatefulWidget {
  final VoidCallback navigateto;
  final VoidCallback exit;
  const PayScreen({super.key, required this.navigateto, required this.exit});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  late SharedPreferences _prefs;

  double? price;
  int paid = 0;
  Timer? _timer;
  Future<void> fetchAndStoreFilesData() async {
    final prefs = await SharedPreferences.getInstance();
    final orderId = prefs.getString('orderId');
    final url = '$baseUrl/api/showbyorder/$orderId';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization':
            'My9cdqbK0TPmdUkb2UpUK79Tkxr1Jf2RUluqjwWDT4jKt8uoxqplwCQ37SlUWNxHwORuZ9qQY1M4Ns5bHNXDNfCBK0D1TLJPbZj9dZ8dV7WJtIF2QApYWaIdO7vBzC8qhLccDkVaCK2ZCMtFAx5MtU6pmybQ8TnsBU5DpQzeah671360isoV5NccxaQz4szqDm1tOIpzV9dp1R58eKInWtuG7HTlebeqvTOhxNKOadTIXNmPw5jt775A5EYVfMXl5shdKAv9ipv3qRPPkI9c60JnoT1kscjpVkzdfzurMRKkHiJD013kOCjryatuylqgoo0vMozHN739rM6fKEcp4BIB06xkplL4ThO9tE4mlVNQZuhZWljyze1lyjKuscuYucmVhZCIsInByZXNldC53cml0ZSJdfQ.cGVM4LCJpYXQiOjE3MjAyMDIwOTIuOTcETdbGkhO0qj',
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final filesData = jsonData['data'];
        final int numberPages = jsonData['number_pages'];
        // Store files data in shared preferences as a list

        await prefs.setStringList('filesData',
            filesData.map((file) => json.encode(file)).toList().cast<String>());
        await prefs.setInt('numberPages', numberPages);
        debugPrint('Files data stored in shared preferences: ${response.body}');
      } else {
        debugPrint(
            'Failed to fetch files data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error occurred while fetching files data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        price = _prefs.getDouble('totalPrice');
      });
    });

    fetchAndStoreFilesData();
    _startExitTimer();
  }

  void incrementPaid() {
    setState(() {
      if (paid < price!) {
        paid += 1;
        if (paid >= price!) {
          widget.navigateto();
        }
      }
    });
  }

  void _startExitTimer() {
    _timer = Timer(const Duration(minutes: 1), () async {
      final prefs = await SharedPreferences.getInstance();
      final orderId = prefs.getString('orderId');
      final directory = Directory(
          '/Users/rodainaomaer/Library/Containers/com.example.buntMachine/Data/Documents/$orderId');
      if (paid == 0) {
        if (await directory.exists()) {
          await directory.delete(recursive: true);
        }
        widget.exit();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    
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
            body: Center(
              child: SizedBox(
                width: 424,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'insert $price dinar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          color: lowlightColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      '$paid/ $price Dinar inserted',
                      style: TextStyle(
                        fontSize: 16,
                        color: coolblack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 38),
                    Stack(
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
                              onTap: incrementPaid,
                              child: Icon(
                                Icons.arrow_downward_rounded,
                                color: lowlightColor,
                                size: 250 * 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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
