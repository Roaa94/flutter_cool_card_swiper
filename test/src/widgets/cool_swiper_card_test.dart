import 'package:flutter/material.dart';
import 'package:flutter_cool_card_swiper/flutter_cool_card_swiper.dart';
import 'package:flutter_cool_card_swiper/src/widgets/cool_swiper_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'dragged card has a small angle rotation animation that resets '
    'when released before passing animationStartDistance',
    (WidgetTester tester) async {
      const int cardsCount = 5;
      const int currentCardIndex = 0;
      const double screenWidth = 300;
      const double cardsHeight = 200;
      const double topLeftXDragPosition = screenWidth / 2 - 1;
      const double topLeftYDragPosition = cardsHeight / 2 - 1;
      const Offset dragStartLocation =
          Offset(topLeftXDragPosition, topLeftYDragPosition);

      final config = CoolCardSwiperConfig(
        direction: SwipeDirection.upwards,
        height: cardsHeight,
        onTapRotationAngle: 180,
        animationStartDistance: 50,
      );

      tester.binding.window.physicalSizeTestValue =
          Size(screenWidth, cardsHeight);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            height: cardsHeight,
            width: screenWidth,
            child: CoolSwiperCard(
              cardsCount: cardsCount,
              index: currentCardIndex,
              config: config,
              onAnimationTrigger: () {},
              child: Container(
                key: Key('__child__'),
                color: Colors.red,
              ),
            ),
          ),
        ),
      );

      final smallAngleRotationWidgetFinder = find
          .byKey(Key('__small_angle_rotation_widget_${currentCardIndex}__'));
      AnimatedRotation smallAngleRotationWidget =
          tester.widget<AnimatedRotation>(smallAngleRotationWidgetFinder);
      // Initially, the card is rotated 0 turns
      expect(smallAngleRotationWidget.turns, equals(0));

      // Start the drag on the card at a location in the top left area
      final TestGesture gesture = await tester.startGesture(dragStartLocation);
      await tester.pump(config.smallAngleRotationDuration);

      // Find the updated widget
      smallAngleRotationWidget =
          tester.widget<AnimatedRotation>(smallAngleRotationWidgetFinder);

      // the config onTapRotationAngle here is 180, which is half a turn
      // thus, upon starting to drag the card, it should animate its turns to 0.5
      expect(
        smallAngleRotationWidget.turns,
        equals(0.5),
      );

      // Drag the card a distance less than the animationStartDistance then release it
      await gesture.moveBy(Offset(0, -10));
      await gesture.up();
      await tester.pump(config.smallAngleRotationDuration);

      // Find the released widget
      final releasedSmallAngleRotationWidget =
          tester.widget<AnimatedRotation>(smallAngleRotationWidgetFinder);
      // The released widget should go back into place and return to a turns value of 0
      expect(
        releasedSmallAngleRotationWidget.turns,
        equals(0),
      );

      addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    },
  );

  testWidgets(
    'card dragged beyond animationStartDistance is thrown up, rotates, '
    'then slides back into place '
    'and scales down into the size of the smallest card in the stack',
    (WidgetTester tester) async {
      const int cardsCount = 5;
      const int currentCardIndex = 1;
      const double screenWidth = 300;
      const double cardsHeight = 200;

      final config = CoolCardSwiperConfig(
        direction: SwipeDirection.upwards,
        height: cardsHeight,
        onTapRotationAngle: 180,
        animationStartDistance: 50,
      );

      tester.binding.window.physicalSizeTestValue =
          Size(screenWidth, cardsHeight);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            height: cardsHeight,
            width: screenWidth,
            child: CoolSwiperCard(
              cardsCount: cardsCount,
              index: currentCardIndex,
              config: config,
              child: Container(
                key: Key('__child__'),
                color: Colors.red,
              ),
              onAnimationTrigger: () {},
            ),
          ),
        ),
      );

      final gestureDetectorFinder = find.byType(GestureDetector);
      expect(gestureDetectorFinder, findsOneWidget);

      final scaleAnimationWidgetFinder =
          find.byKey(Key('__swipe_scale_animation_${currentCardIndex}__'));
      Transform scaleAnimationWidget =
          tester.widget<Transform>(scaleAnimationWidgetFinder);
      expect(
        scaleAnimationWidget.transform.entry(0, 0),
        equals(1),
      );

      await tester.drag(gestureDetectorFinder, Offset(0, -60));
      await tester.pumpAndSettle();

      // The scale of the card is now equal to the scale of the
      // scale of the last card in the back of the stack
      scaleAnimationWidget =
          tester.widget<Transform>(scaleAnimationWidgetFinder);
      expect(
        scaleAnimationWidget.transform.entry(0, 0),
        equals(config.minCardScaleFraction),
      );

      addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    },
  );

  testWidgets(
    'dragDuration is set to zero when drag starts',
    (WidgetTester tester) async {
      //...
    },
  );
}
