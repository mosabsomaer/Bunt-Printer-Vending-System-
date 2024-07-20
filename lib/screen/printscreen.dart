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
  final VoidCallback exit;
  const PrintScreen({super.key, required this.navigateto, required this.exit});

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  Map<String, dynamic> sharedData = {};
  Map<String, dynamic> sharedDataString = {};
  List<Map<String, dynamic>> filesDataList = [];
  bool action = true;
  int? s;

  Future<void> printFiles(BuildContext context) async {
    // Get the directory path
    const directoryPath =
        '/Users/rodainaomaer/Library/Containers/com.example.buntMachine/Data/Documents';

    // Retrieve the order ID from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final orderId = prefs.getString('orderId');
    s = prefs.getInt('numberPages');

    Map<String, dynamic> sharedDataString = {};
    List<Map<String, dynamic>> filesDataList = [];

    sharedDataString['filesData'] = prefs.getStringList('filesData');
    if (sharedDataString['filesData'] != null) {
      // Combine the list of JSON strings into a single JSON array string
      final jsonArrayString = '[${sharedDataString['filesData']!.join(',')}]';
      final jsonData = json.decode(jsonArrayString);
      filesDataList = List<Map<String, dynamic>>.from(jsonData);

      // Print the individual items in the filesData list
      for (final item in filesDataList) {
        debugPrint(item.toString());
      }
    }

    // Check if the order ID is not null
    if (orderId != null) {
      final directory = Directory('$directoryPath/$orderId');

      // Check if the directory exists
      if (await directory.exists()) {
        // Get all the files in the directory
        final files = await directory.list().toList();

        // Loop through the filesDataList
        for (final fileData in filesDataList) {
          final fileName = fileData['file_name'];
          final copies = fileData['copies'];

          // Find the matching file in the directory
          for (final file in files) {
            if (file is File && file.uri.pathSegments.last == fileName) {
              // Print the file multiple times based on the number of copies
              for (int i = 0; i < copies; i++) {
                await Printing.directPrintPdf(
                  printer: const Printer(url: 'HP LaserJet M101-M106'),
                  onLayout: (format) => file.readAsBytes(),
                );
              }

              debugPrint(
                  'File: $fileName, Copies: $copies, ColorMode: ${fileData['color_mode']}');
              break; // Exit the loop once the file is printed
            }
          }
        }
        directory.delete(recursive: true);
        try {
          final response = await http.put(
            Uri.parse('$baseUrl/api/orders/$orderId'),
            body: {"status": "Completed"},
          );
          print(response.body);
        } catch (e) {
          throw Exception('Failed to update order');
        }

        setState(() {
          action = !action; // Toggle the value of 'action'
        });
        Future.delayed(const Duration(seconds: 8), () {
          widget.navigateto();
        });
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

  void getFileDetails(String fileName) {
    for (final fileData in filesDataList) {
      if (fileData['file_name'] == fileName) {
        final copies = fileData['copies'];
        final colorMode = fileData['color_mode'];
        debugPrint('File: $fileName, Copies: $copies, ColorMode: $colorMode');
        return;
      }
    }
    debugPrint('File not found: $fileName');
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
                      action
                          ? 'Downloading Documents'
                          : 'Printing \n $s papers',
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
