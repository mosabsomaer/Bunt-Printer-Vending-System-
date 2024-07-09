import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key});

 Future<void> printFiles(BuildContext context) async {
    // Get the directory path
    const directoryPath = '/Users/rodainaomaer/Library/Containers/com.example.buntMachine/Data/Documents';

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
            await Printing.directPrintPdf(
              printer: const Printer(url: 'HP LaserJet M101-M106'),
              onLayout: (format) => file.readAsBytes(),
            );
          }
        }
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Directory not found.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print PDF'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => printFiles(context),
          child: const Text('Print All Files'),
        ),
      ),
    );
  }
}
