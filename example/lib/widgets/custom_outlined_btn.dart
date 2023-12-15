import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final StatefulWidget screen;

  const CustomOutlinedButton({
    super.key,
    required this.screen,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => screen),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    );
  }
}
