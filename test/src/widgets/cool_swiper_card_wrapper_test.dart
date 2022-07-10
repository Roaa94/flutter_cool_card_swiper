import 'package:flutter/material.dart';
import 'package:flutter_cool_card_swiper/flutter_cool_card_swiper.dart';
import 'package:flutter_cool_card_swiper/src/widgets/cool_swiper_card_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'card transforms from its original scale to the scale of the next card',
    (WidgetTester tester) async {
      const int cardsCount = 5;
      const int currentCardIndex = 0;

      final config = CoolCardSwiperConfig(
        direction: SwipeDirection.upwards,
        minCardScaleFraction: 0.5,
      );

      final double currentCardScale = config.getCurrentCardScale(
        cardsCount,
        currentCardIndex,
      );

      final AnimationController animationController = AnimationController(
        duration: config.backgroundCardsAnimationDuration,
        vsync: const TestVSync(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoolSwiperCardWrapper(
              index: currentCardIndex,
              cardsCount: cardsCount,
              config: config,
              animationController: animationController,
              child: Container(),
            ),
          ),
        ),
      );

      final scaleTransformWidgetFinder =
          find.byKey(Key('__${currentCardIndex}_swiper_card_wrapper__'));
      expect(scaleTransformWidgetFinder, findsOneWidget);

      final scaleTransformWidget =
          tester.widget<Transform>(scaleTransformWidgetFinder.first);
      // Initially the card has the default scale according to its location
      expect(
        scaleTransformWidget.transform.entry(0, 0),
        equals(currentCardScale),
      );

      animationController.forward();
      await tester.pumpAndSettle();

      final newScaleTransformWidget =
          tester.widget<Transform>(scaleTransformWidgetFinder.first);

      // After the animation completes, the card has the scale of the card in front of it
      expect(
        newScaleTransformWidget.transform.entry(0, 0),
        equals(currentCardScale + config.getCardScaleDifference(cardsCount)),
      );
    },
  );
}
