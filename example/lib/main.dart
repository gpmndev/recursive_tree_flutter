import 'package:flutter/material.dart';

import 'screens/ex_expandable_tree_screen.dart';
import 'screens/ex_lazy_stack_screen.dart';
import 'screens/ex_lazy_tree_single_choice.dart';
import 'screens/ex_stack_screen.dart';
import 'screens/ex_tree_single_choice.dart';
import 'screens/ex_tree_vietnam_regions.dart';
import 'screens/vts/ex_vts_department_tree_screen.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              context,
              const ExStackScreen(),
              "Stack Tree\nmultiple choice - parse data 1 time",
            ),
            _buildButton(
              context,
              const ExLazyStackScreen(),
              "Lazy Stack Tree\nmultiple choice - parse data run-time",
            ),
            //_____________________
            const Divider(
              thickness: 2,
              height: 50,
              color: Colors.black,
            ),
            //_____________________
            _buildButton(
              context,
              const ExExpandableTreeScreen(),
              "Expandable Tree\nmultiple choice - parse data 1 time",
            ),
            _buildButton(
              context,
              const ExVTSDeptTreeScreen(),
              "VTS Department Tree Screen",
            ),
            //_____________________
            const Divider(
              thickness: 2,
              height: 50,
              color: Colors.black,
            ),
            //_____________________
            _buildButton(
              context,
              const ExTreeSingleChoice(),
              "Expandable Tree\nsingle choice - parse data 1 time",
            ),
            _buildButton(
              context,
              const ExLazyTreeSingleChoice(),
              "Expandable Tree\nsingle choice - lazy loading",
            ),
            //_____________________
            _buildButton(
              context,
              const ExTreeSingleChoice(),
              "Expandable Tree\nsingle choice - parse data 1 time",
            ),
            _buildButton(
              context,
              const ExTreeVNRegions(),
              "Vietnam regions tree",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
          BuildContext context, StatefulWidget screen, String title) =>
      OutlinedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => screen),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      );
}
