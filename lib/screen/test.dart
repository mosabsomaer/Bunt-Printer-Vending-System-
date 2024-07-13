import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Map<String, dynamic> sharedData = {};
  Map<String, dynamic> sharedDataString = {};
  List<Map<String, dynamic>> filesDataList = [];
  @override
  void initState() {
    super.initState();
    fetchSharedData();
    _loadSharedPrefs();
  }



  Future<void> _loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
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

    setState(() {
      sharedData = sharedDataString;
    });

    // Print the retrieved values
  }
 void getFileDetails(String fileName) {
    for (final fileData in filesDataList) {
      if (fileData['file_name'] == fileName) {
        final pageCount = fileData['PageCount'];
        final colorMode = fileData['color_mode'];
        debugPrint('File: $fileName, PageCount: $pageCount, ColorMode: $colorMode');
        return;
      }
    }
    debugPrint('File not found: $fileName');
  }





  


Future<void> fetchSharedData() async {
  final prefs = await SharedPreferences.getInstance();
  final sharedDataString = <String, dynamic>{};

  sharedDataString['totalPrice'] = prefs.getInt('totalPrice')?.toString();
  sharedDataString['orderId'] = prefs.getString('orderId');
  sharedDataString['filesData'] = prefs.getStringList('filesData');
  sharedDataString['numberPages'] = prefs.getInt('numberPages');

  setState(() {
    sharedData = sharedDataString;
  });

  // Print the retrieved values
  debugPrint(sharedData['totalPrice']);
  debugPrint(sharedData['orderId']);


  // Print the individual items in the filesData list
  if (sharedData['filesData'] != null) {
    final filesDataList = sharedData['filesData'] as List<String>;
    for (final item in filesDataList) {
      debugPrint(item);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crunching PlayGround \n Mess Around as you wish',
          style: TextStyle(backgroundColor: Colors.orangeAccent),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchSharedData,
              child: const Text('Refresh Shared Data'),
            ),
            const SizedBox(height: 16),
          if (sharedData.isNotEmpty)
  Expanded(
    child: ListView.builder(
      itemCount: sharedData.length,
      itemBuilder: (context, index) {
        final key = sharedData.keys.elementAt(index);
        final value = sharedData[key];

        return ListTile(
          title: Text(key),
          subtitle: Text('$value'),
        );
      },
    ),
  )
else
  const Text('No shared data found in shared preferences'),
            const SizedBox(height: 16),
           
                      ElevatedButton(
              onPressed: () => getFileDetails('1720272183-watch.pdf'),
              child: const Text('Get Details for 1720272183-watch.pdf'),
            ),
            ElevatedButton(
              onPressed: () => getFileDetails('1720435135-Postman_Request_Example.pdf'),
              child: const Text('Get Details for 1720435135-Postman_Request_Example.pdf'),
            ),
            ElevatedButton(
              onPressed: () => getFileDetails('1720435365-lecture 4.pdf'),
              child: const Text('Get Details for 1720435365-lecture 4.pdf'),
            ),],
        ),
      ),
    );
  }
}