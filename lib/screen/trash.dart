import 'package:flutter/material.dart';

class Tbomb extends StatelessWidget {
  const Tbomb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius:
                  BorderRadius.circular(10), // Adjust the radius as needed
            ),
            child: const Text(
              "React.js",
              style: TextStyle(color: Colors.yellow),
            ),
          )
        ],
      ),
    );
  }
}
