import 'package:flutter/material.dart';

import 'swipe_direction.dart';

class CoolCardSwiperConfig {
  const CoolCardSwiperConfig({
    this.height = 220,
    this.direction = SwipeDirection.upwards,
    this.animationStartDistance = 100,
    this.turns = 1,
    this.onTapRotationAngle = 4,
    this.isListReversed = true,
    this.minCardScaleFraction = 0.7,
    this.throwDistanceOnDragEnd = 300,
  })  : assert(
          minCardScaleFraction > 0 && minCardScaleFraction < 1,
          'minCardScaleFraction should be more than 0 and less than 1',
        ),
        assert(
          throwDistanceOnDragEnd >= 200,
          'throwDistanceOnDragEnd should be larger than 100',
        );

  /// The height of the swiper
  final double height;

  /// The direction in which the cards are thrown and
  /// the swap is achieved and the background cards appear
  final SwipeDirection direction;

  /// The distance after which releasing the card will animate it and swipe it
  /// If the user releases before this distance, the card will snap back into place
  final double animationStartDistance;

  /// The number of complete turns the cards will perform
  /// when flying up and sliding down to the back of the stack
  final int turns;

  /// The angle, in degrees, in which the card will slightly rotate
  /// when the user first taps/click on it
  final double onTapRotationAngle;

  /// The scale fraction of the smallest card
  /// relative to the largest card (should be > 0 & < 1)
  final double minCardScaleFraction;

  /// If set to true, the last item in the list of
  /// children will be the foremost card
  /// If false, the first item in the list of children
  /// will be the foremost card
  final bool isListReversed;

  /// The distance in which the card is thrown further from
  /// the drag end location before it is returned back down
  final double throwDistanceOnDragEnd;

  Alignment get cardsScaleOriginAlignment =>
      Alignment(0, 2.3 * direction.multiplier);

  /// Animation duration for animating the background cards
  /// of the card being swiped (the animation of the background cards
  /// scaling up to replace the card being swiped)
  final Duration backgroundCardsAnimationDuration =
      const Duration(milliseconds: 300);

  /// Animation duration for the rotate & swap animation of the
  /// card being dragged
  /// i.e. the duration between releasing the card and the card
  /// reaching its final place
  final Duration swipeAnimationDuration = const Duration(milliseconds: 500);

  double getCurrentCardScale(int cardsCount, int index) {
    return minCardScaleFraction +
        ((1 - minCardScaleFraction) / cardsCount) * (index + 1);
  }

  double getPreviousCardScale(int cardsCount, int index) {
    return minCardScaleFraction +
        ((1 - minCardScaleFraction) / cardsCount) * index;
  }

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