import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/constants.dart';

class AnimatedCardWrapper extends StatefulWidget {
  final Widget child;
  final double initialScale;
  final double initialYOffset;
  final bool fire;

  const AnimatedCardWrapper({
    Key? key,
    required this.child,
    this.initialScale = 1,
    this.initialYOffset = 0,
    this.fire = false,
  }) : super(key: key);

  @override
  State<AnimatedCardWrapper> createState() => _AnimatedCardWrapperState();
}

class _AnimatedCardWrapperState extends State<AnimatedCardWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> yOffsetAnimation;
  late final Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Constants.backgroundCardsAnimationDuration,
    );

    yOffsetAnimation = Tween<double>(
      begin: widget.initialYOffset,
      end: widget.initialYOffset + Constants.yOffset,
    ).animate(animationController);

    scaleAnimation = Tween<double>(
      begin: widget.initialScale,
      end: widget.initialScale + Constants.scaleFraction,
    ).animate(animationController);
  }

  @override
  void didUpdateWidget(covariant AnimatedCardWrapper oldWidget) {
    print('widget.fire');
    print(widget.fire);
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
