import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 4, dashSpace = 2, startX = 0;
    double dashWidth2 = 4, dashSpace2 = 2, startX2 = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
    while (startX2 < size.height) {
      canvas.drawLine(
          Offset(0, startX2), Offset(0, startX2 + dashWidth2), paint);
      startX2 += dashWidth2 + dashSpace2;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BottomDashedLinePainterWhenClicked extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth2 = 4, dashSpace2 = 2, startX2 = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    while (startX2 < size.height) {
      canvas.drawLine(Offset(size.width / 2, startX2),
          Offset(size.width / 2, startX2 + dashWidth2), paint);
      startX2 += dashWidth2 + dashSpace2;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TopDashedLinePainterWhenClicked extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 4, dashSpace = 2, startX = 0;
    double dashWidth2 = 4, dashSpace2 = 2, startX2 = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    while (startX2 < size.height / 2.5) {
      canvas.drawLine(
          Offset(0, startX2), Offset(0, startX2 + dashWidth2), paint);
      startX2 += dashWidth2 + dashSpace2;
    }
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
