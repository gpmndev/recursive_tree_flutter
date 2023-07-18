import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, this.error}) : super(key: key);
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Lottie.asset(
            'assets/lottie/red_alert.json',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "ERROR",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
