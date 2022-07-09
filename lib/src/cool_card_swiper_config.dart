import 'package:flutter_cool_card_swiper/src/constants.dart';

class CoolCardSwiperConfig {
  CoolCardSwiperConfig({
    this.height = Constants.cardHeight,
    this.direction = SwipeDirection.upwards,
  });

  /// The height of the swiper
  final double height;

  /// The direction in which the cards are thrown and
  /// the swap is achieved and the background cards appear
  final SwipeDirection direction;
}

enum SwipeDirection {
  upwards,
  downwards,
}