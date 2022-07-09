import 'package:flutter/material.dart';

import '../cool_card_swiper_config.dart';

/// This widget is responsible for scaling up & sliding down
/// the background cards of the the card being dragged to give the
/// illusion that they replaced it
///
/// the animationController is passed to it from the parent widget
/// because the parent widget calls the forward() method on it
/// when it knows that the rotation main animation has been triggerred
class CoolSwiperCardWrapper extends StatefulWidget {
  final Widget child;
  final AnimationController animationController;
  final int index;
  final int cardsCount;
  final CoolCardSwiperConfig config;

  const CoolSwiperCardWrapper({
    Key? key,
    required this.child,
    required this.animationController,
    required this.index,
    required this.cardsCount,
    required this.config,
  }) : super(key: key);

  @override
  State<CoolSwiperCardWrapper> createState() => _CoolSwiperCardWrapperState();
}

class _CoolSwiperCardWrapperState extends State<CoolSwiperCardWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    double previousCardScale = widget.config.getPreviousCardScale(
      widget.cardsCount,
      widget.index,
    );

    double currentCardScale = widget.config.getCurrentCardScale(
      widget.cardsCount,
      widget.index,
    );

    animationController = widget.animationController;

    scaleAnimation = Tween<double>(
      begin: currentCardScale,
      end: currentCardScale + currentCardScale - previousCardScale,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (c, child) => Transform.scale(
        alignment: widget.config.cardsScaleOriginAlignment,
        scale: scaleAnimation.value,
        child: child,
      ),
      child: widget.child,
    );
  }
}
