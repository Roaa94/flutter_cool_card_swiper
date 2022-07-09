import 'package:flutter/material.dart';
import 'package:flutter_cool_card_swiper/src/constants.dart';

class CoolCardSwiperConfig {
  const CoolCardSwiperConfig({
    this.height = Constants.cardHeight,
    this.direction = SwipeDirection.upwards,
    this.animationStartDistance = Constants.animationStartDistance,
  });

  /// The height of the swiper
  final double height;

  /// The direction in which the cards are thrown and
  /// the swap is achieved and the background cards appear
  final SwipeDirection direction;

  /// The distance after which releasing the card will animate it and swipe it
  /// If the user releases before this distance, the card will snap back into place
  final double animationStartDistance;

  Alignment getDragStartPositionAlignment(
    double xPosition,
    double yPosition,
    double width,
  ) {
    if (xPosition > width / 2) {
      return yPosition > height / 2
          ? Alignment.bottomRight
          : Alignment.topRight;
    } else {
      return yPosition > height / 2 ? Alignment.bottomLeft : Alignment.topLeft;
    }
  }
}

enum SwipeDirection {
  upwards,
  downwards,
}
