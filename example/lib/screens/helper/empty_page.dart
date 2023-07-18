import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyPage extends StatefulWidget {
  const EmptyPage({Key? key, this.message}) : super(key: key);
  final String? message;

  @override
  State<EmptyPage> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Lottie.asset(
            'assets/lottie/emptyBox.json',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          const SizedBox(
            height: 5,
          ),
          const Text("EMPTY"),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
