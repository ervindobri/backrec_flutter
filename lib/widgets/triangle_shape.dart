import 'package:flutter/material.dart';

class DrawTriangleShape extends CustomPainter {
  late Paint painter;

  DrawTriangleShape({required Color color}) {
    painter = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(size.height / 2, size.width);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
