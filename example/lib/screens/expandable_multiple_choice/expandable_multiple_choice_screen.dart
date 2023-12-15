import 'package:flutter/material.dart';

import '../../widgets/custom_outlined_btn.dart';
import 'ex_expandable_tree_expanded_screen.dart';
import 'ex_expandable_tree_screen.dart';

class ExpandableMultipleChoiceScreen extends StatefulWidget {
  const ExpandableMultipleChoiceScreen({super.key});

  @override
  State<ExpandableMultipleChoiceScreen> createState() =>
      _ExpandableMultipleChoiceScreenState();
}

class _ExpandableMultipleChoiceScreenState
    extends State<ExpandableMultipleChoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expandable Multiple Choice"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomOutlinedButton(
              screen: ExExpandableTreeScreen(),
              title: "Expandable Tree\nmultiple choice - parse data 1 time",
            ),
            SizedBox(height: 20),
            CustomOutlinedButton(
              screen: ExExpandableTreeExpandedScreen(),
              title:
                  "Expandable Tree expands first\nmultiple choice - parse data 1 time",
            ),
          ],
        ),
      ),
    );
  }
}
