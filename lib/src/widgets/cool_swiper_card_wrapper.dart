import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/src/constants.dart';

/// This widget is responsible for scaling up & sliding down
/// the background cards of the the card being dragged to give the
/// illusion that they replaced it
///
/// the animationController is passed to it from the parent widget
/// because the parent widget calls the forward() method on it
/// when it knows that the rotation main animation has been triggerred
class CoolSwiperCardWrapper extends StatefulWidget {
  final Widget child;
  final double initialScale;
  final double initialYOffset;
  final bool fire;
  final AnimationController animationController;

  const CoolSwiperCardWrapper({
    Key? key,
    required this.child,
    this.initialScale = 1,
    this.initialYOffset = 0,
    this.fire = false,
    required this.animationController,
  }) : super(key: key);

  @override
  State<CoolSwiperCardWrapper> createState() => _CoolSwiperCardWrapperState();
}

class _CoolSwiperCardWrapperState extends State<CoolSwiperCardWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> yOffsetAnimation;
  late final Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    animationController = widget.animationController;

    yOffsetAnimation = Tween<double>(
      begin: widget.initialYOffset,
      end: widget.initialYOffset - Constants.yOffset,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutBack,
      ),
    );

    scaleAnimation = Tween<double>(
      begin: widget.initialScale,
      end: widget.initialScale + Constants.scaleFraction,
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
      builder: (c, child) => Transform.translate(
        offset: Offset(0, -yOffsetAnimation.value),
        child: Transform.scale(
          scale: scaleAnimation.value,
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
