import 'package:flutter/material.dart';

import '../../widgets/custom_outlined_btn.dart';
import 'ex_lazy_stack_screen.dart';
import 'ex_stack_screen.dart';

class StackScreen extends StatefulWidget {
  const StackScreen({super.key});

  @override
  State<StackScreen> createState() => _StackScreenState();
}

class _StackScreenState extends State<StackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stack Screen Example")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomOutlinedButton(
              screen: ExStackScreen(),
              title: "Stack Tree\nmultiple choice - parse data 1 time",
            ),
            SizedBox(height: 20),
            CustomOutlinedButton(
              screen: ExLazyStackScreen(),
              title: "Lazy Stack Tree\nmultiple choice - parse data run-time",
            ),
          ],
        ),
      ),
    );
  }
}
