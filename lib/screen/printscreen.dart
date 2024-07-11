import 'dart:convert';
import 'dart:io';

import 'package:bunt_machine/helpers/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class PrintScreen extends StatefulWidget {
  final VoidCallback navigateto;

  const PrintScreen({super.key, required this.navigateto});

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  bool action = true;
Future<void> fetchAndStoreFilesData(String orderId) async {
  final url = 'http://127.0.0.1:8000/api/orders/$orderId';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final filesData = jsonData['data'];

      // Store files data in shared preferences as a list
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('filesData', filesData.map((file) => json.encode(file)).toList().cast<String>());

      debugPrint('Files data stored in shared preferences: ${response.body}');
    } else {
      debugPrint('Failed to fetch files data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error occurred while fetching files data: $e');
  }
}


  Future<void> printFiles(BuildContext context) async {
    // Get the directory path
    const directoryPath =
        '/Users/rodainaomaer/Library/Containers/com.example.buntMachine/Data/Documents';

    // Retrieve the order ID from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final orderId = prefs.getString('orderId');

    // Check if the order ID is not null
    if (orderId != null) {
      final directory = Directory('$directoryPath/$orderId');

      // Check if the directory exists
      if (await directory.exists()) {
        // Get all the files in the directory
        final files = await directory.list().toList();

        // Print each file
        for (final file in files) {
          if (file is File) {
            debugPrint(file.toString());
            await Printing.directPrintPdf(
              printer: const Printer(url: 'HP LaserJet M101-M106'),
              onLayout: (format) => file.readAsBytes(),
            );
          }
        }
        setState(() {
          action = !action; // Toggle the value of 'action'
        });
        // widget.navigateto();
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Files not found.'),
          ),
        );
      }
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order ID not found.'),
        ),
      );
    }
  }

  Future<void> printPrintingInfo() async {
    final printingInfo = await Printing.info();
    print(printingInfo);
  }

  @override
  void initState() {
    super.initState();
    printFiles(context);
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
                    Text(
                      action ? 'Downloading Documents' : 'Printing\n6 papers',
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
                        printPrintingInfo();
                      },
                      child: Text("data"),
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
