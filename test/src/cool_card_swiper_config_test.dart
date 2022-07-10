import 'package:flutter/material.dart';
import 'package:flutter_cool_card_swiper/flutter_cool_card_swiper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('assertion tests', () {
    test('assertion errors are thrown for invalid values', () {
      expect(
        () => CoolCardSwiperConfig(minCardScaleFraction: -1),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => CoolCardSwiperConfig(minCardScaleFraction: 1.1),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => CoolCardSwiperConfig(throwDistanceOnDragEnd: 0),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('multiplier & multiplierReversed tests', () {
    test(
      'multiplier of upwards direction is -1, and reverse multiplier is +1',
      () {
        final config = CoolCardSwiperConfig(direction: SwipeDirection.upwards);

        expect(config.direction.multiplier, equals(-1));
        expect(config.direction.multiplierReversed, equals(1));
      },
    );

    test(
      'multiplier of downwards direction is 1, and reverse multiplier is -1',
      () {
        final config =
            CoolCardSwiperConfig(direction: SwipeDirection.downwards);

        expect(config.direction.multiplier, equals(1));
        expect(config.direction.multiplierReversed, equals(-1));
      },
    );
  });

  group('Cards scale origin alignment tests', () {
    test(
      'Cross Origin Alignment y axis is negative for upwards direction',
      () {
        final config = CoolCardSwiperConfig(direction: SwipeDirection.upwards);

        expect(
          config.cardsScaleOriginAlignment,
          equals(Alignment(0, -config.cardsScaleOriginAlignmentYValue)),
        );
      },
    );

    test(
      'Cross Origin Alignment y axis is positive for downwards direction',
      () {
        final config =
            CoolCardSwiperConfig(direction: SwipeDirection.downwards);

        expect(
          config.cardsScaleOriginAlignment,
          equals(Alignment(0, config.cardsScaleOriginAlignmentYValue)),
        );
      },
    );
  });

  group('card scale tests', () {
    test(
      'card scales is distributed evenly between minCardScaleFraction & 1',
      () {
        final int cardsCount = 5;

        final config = CoolCardSwiperConfig(
          direction: SwipeDirection.upwards,
          minCardScaleFraction: 0.5,
        );

        int precision = 10;
        double cardScale0 = config.getCurrentCardScale(cardsCount, 0);
        double cardScale1 = config.getCurrentCardScale(cardsCount, 1);
        final difference1 =
            ((cardScale1 - cardScale0) * precision).round() / precision;

        double cardScale2 = config.getCurrentCardScale(cardsCount, 2);
        final difference2 =
            ((cardScale2 - cardScale1) * precision).round() / precision;

        expect(difference1, equals(difference2));
      },
    );

    test('can get previous card scale', () {
      final int cardsCount = 5;

      final config = CoolCardSwiperConfig(
        direction: SwipeDirection.upwards,
        minCardScaleFraction: 0.5,
      );

      expect(
        config.getCurrentCardScale(cardsCount, 0),
        equals(config.getPreviousCardScale(cardsCount, 1)),
      );
    });
  });

  group('Drag start position alignment tests', () {
    test(
      'returns topRight alignment if the drag start position is in the top right area',
      () {
        final double screenWidth = 200;
        final config = CoolCardSwiperConfig(
          height: 100,
        );

        // The drag start position is in the top right if
        // x > (200 / 2) && y < (100 / 2)
        expect(
          config.getDragStartPositionAlignment(110, 49, screenWidth),
          equals(Alignment.topRight),
        );
      },
    );

    test(
      'returns topLeft alignment if the drag start position is in the top left area',
      () {
        final double screenWidth = 200;
        final config = CoolCardSwiperConfig(
          height: 100,
        );

        // The drag start position is in the top right if
        // x < (200 / 2) && y < (100 / 2)
        expect(
          config.getDragStartPositionAlignment(99, 49, screenWidth),
          equals(Alignment.topLeft),
        );
      },
    );

    test(
      'returns bottomRight alignment if the drag start position is in the bottom right area',
      () {
        final double screenWidth = 200;
        final config = CoolCardSwiperConfig(
          height: 100,
        );

        // The drag start position is in the top right if
        // x > (200 / 2) && y > (100 / 2)
        expect(
          config.getDragStartPositionAlignment(101, 51, screenWidth),
          equals(Alignment.bottomRight),
        );
      },
    );

    test(
      'returns bottomLeft alignment if the drag start position is in the bottom left area',
      () {
        final double screenWidth = 200;
        final config = CoolCardSwiperConfig(
          height: 100,
        );

        // The drag start position is in the top right if
        // x < (200 / 2) && y > (100 / 2)
        expect(
          config.getDragStartPositionAlignment(99, 51, screenWidth),
          equals(Alignment.bottomLeft),
        );
      },
    );
  });
}
