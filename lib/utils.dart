import 'package:flutter/material.dart';

Alignment getDragStartPositionAlignment(
  double xPosition,
  double yPosition,
  double width,
  double height,
) {
  if (xPosition > width / 2) {
    return yPosition > height / 2 ? Alignment.bottomRight : Alignment.topRight;
  } else {
    return yPosition > height / 2 ? Alignment.bottomLeft : Alignment.topLeft;
  }
}
