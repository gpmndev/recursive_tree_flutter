import 'package:flutter/material.dart';

import 'fading_circle.dart';

//? [DefaultHandleBar] _________________________________________________________
class DefaultHandleBar extends StatelessWidget {
  const DefaultHandleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        width: 60,
        height: 7,
        decoration: const BoxDecoration(
          color: Color(0xFFB5B5C3),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }
}

//? [DefaultLeadingWidget] _____________________________________________________
class DefaultLeadingWidget extends StatelessWidget {
  const DefaultLeadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back, size: 20),
    );
  }
}

//? [DefaultTrailingWidget] ____________________________________________________
class DefaultTrailingWidget extends StatelessWidget {
  const DefaultTrailingWidget(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF015DB7),
          ),
        ),
      ),
    );
  }
}

//? [kDefaultSheetTitleStyle] __________________________________________________
const TextStyle kDefaultSheetTitleStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 16,
  color: Color(0xFF141923),
);

//? [DefaultLoadingWidget] _____________________________________________________
class DefaultLoadingWidget extends StatelessWidget {
  const DefaultLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: const SpinKitFadingCircle(
        color: Color(0xFF015DB7),
        size: 50.0,
      ),
    );
  }
}
