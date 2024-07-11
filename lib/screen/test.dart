

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Map<String, dynamic> sharedData = {};

  @override
  void initState() {
    super.initState();
    fetchSharedData();
  }


Future<void> fetchSharedData() async {
  final prefs = await SharedPreferences.getInstance();
  final sharedDataString = <String, dynamic>{};

  sharedDataString['totalPrice'] = prefs.getInt('totalPrice')?.toString();
  sharedDataString['orderId'] = prefs.getString('orderId');
  sharedDataString['filesData'] = prefs.getStringList('filesData');

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
           
          ],
        ),
      ),
    );
  }
}