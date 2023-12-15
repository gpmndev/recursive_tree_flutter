import 'package:flutter/material.dart';

import 'screens/expandable_multiple_choice/expandable_multiple_choice_screen.dart';
import 'screens/expandable_single_choice/expandable_single_choice_screen.dart';
import 'screens/stack/stack_screen.dart';
import 'screens/vts/vts_screen.dart';
import 'widgets/custom_outlined_btn.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tree View Flutter Example")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomOutlinedButton(
              screen: StackScreen(),
              title: "Stack",
            ),
            //_____________________
            Divider(
              thickness: 2,
              height: 50,
              color: Colors.black,
            ),
            //_____________________
            CustomOutlinedButton(
              screen: ExpandableMultipleChoiceScreen(),
              title: "Expandable Multiple Choice",
            ),
            //_____________________
            Divider(
              thickness: 2,
              height: 50,
              color: Colors.black,
            ),
            //_____________________
            CustomOutlinedButton(
              screen: ExpandableSingleChoiceScreen(),
              title: "Expandable Single Choice",
            ),
            //_____________________
            Divider(
              thickness: 2,
              height: 50,
              color: Colors.black,
            ),
            //_____________________
            CustomOutlinedButton(
              screen: VTSScreen(),
              title: "VTS Department Tree",
            ),
          ],
        ),
      ),
    );
  }
}
