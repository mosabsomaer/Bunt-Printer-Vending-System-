import 'package:bunt_machine/helpers/consts.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PayScreen extends StatefulWidget {
  final VoidCallback navigateto;
  const PayScreen({super.key, required this.navigateto});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  late SharedPreferences _prefs;

  int? price;
  int paid = 0;
Future<void> fetchAndStoreFilesData(String orderId) async {
  final url = 'http://127.0.0.1:8000/api/showbyorder/$orderId';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final filesData = jsonData['data'];
      final numberPages= jsonData['number_pages'];
      // Store files data in shared preferences as a list
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('filesData', filesData.map((file) => json.encode(file)).toList().cast<String>());
      await prefs.setInt(numberPages, numberPages);
      debugPrint('Files data stored in shared preferences: ${response.body}');
    } else {
      debugPrint('Failed to fetch files data. Status code: ${response.statusCode}');
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
        price = _prefs.getInt('totalPrice');
        debugPrint(_prefs.getInt('totalPrice').toString());
      });
    });
    fetchAndStoreFilesData('547237');
   
  }

  void incrementPaid() {
    setState(() {
      if (paid < price!) {
        paid += 1;
        if (paid == price) {
          widget.navigateto();
        }
      }
    });
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
