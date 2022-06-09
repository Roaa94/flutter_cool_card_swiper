import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/constants.dart';

class AnimatedCardItem extends StatefulWidget {
  const AnimatedCardItem({Key? key}) : super(key: key);

  @override
  State<AnimatedCardItem> createState() => _AnimatedCardItemState();
}

class _AnimatedCardItemState extends State<AnimatedCardItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> rotationAnimation;
  late final Animation<double> slideAnimation;

  double yOffset = 0;
  Duration swipeDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Constants.swipeAnimationDuration,
    );

    rotationAnimation = Tween<double>(
      begin: 0,
      end: -360,
    ).animate(animationController);

    slideAnimation = Tween<double>(
      begin: 0,
      end: -200,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0,
        0.5,
        curve: Curves.ease,
      ),
    ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: yOffset,
      left: 0,
      right: 0,
      duration: swipeDuration,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            yOffset -= details.delta.dy;
          });
        },
        onVerticalDragEnd: (details) {
          animationController.forward().then((_) {
            setState(() {
              // yOffset = -200;
            });
          });
        },
        child: AnimatedBuilder(
          animation: animationController,
          builder: (c, child) {
            return Transform.translate(
              offset: Offset(0, slideAnimation.value),
              child: Transform.rotate(
                angle: rotationAnimation.value * (math.pi / 180),
                alignment: Alignment.center,
                child: Container(
                  height: Constants.cardHeight,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      'Foo',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
