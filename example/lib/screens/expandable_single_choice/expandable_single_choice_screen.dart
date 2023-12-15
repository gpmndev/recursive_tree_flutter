import 'package:flutter/material.dart';

import '../../widgets/custom_outlined_btn.dart';
import 'ex_lazy_tree_single_choice.dart';
import 'ex_tree_single_choice.dart';
import 'ex_vietnam_regions.dart';

class ExpandableSingleChoiceScreen extends StatefulWidget {
  const ExpandableSingleChoiceScreen({super.key});

  @override
  State<ExpandableSingleChoiceScreen> createState() =>
      _ExpandableSingleChoiceScreenState();
}

class _ExpandableSingleChoiceScreenState
    extends State<ExpandableSingleChoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expandable Single Choice"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomOutlinedButton(
              screen: ExTreeSingleChoice(),
              title: "Expandable Tree\nsingle choice - parse data 1 time",
            ),
            SizedBox(height: 20),
            CustomOutlinedButton(
              screen: ExLazyTreeSingleChoice(),
              title: "Expandable Tree\nsingle choice - lazy loading",
            ),
            SizedBox(height: 20),
            CustomOutlinedButton(
              screen: ExVNRegionsTree(),
              title: "Vietnam regions tree",
            ),
          ],
        ),
      ),
    );
  }
}
