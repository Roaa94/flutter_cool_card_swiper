import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/constants.dart';

class SwiperCardWrapper extends StatefulWidget {
  final Widget child;
  final double initialScale;
  final double initialYOffset;
  final bool fire;
  final AnimationController animationController;

  const SwiperCardWrapper({
    Key? key,
    required this.child,
    this.initialScale = 1,
    this.initialYOffset = 0,
    this.fire = false,
    required this.animationController,
  }) : super(key: key);

  @override
  State<SwiperCardWrapper> createState() => _SwiperCardWrapperState();
}

class _SwiperCardWrapperState extends State<SwiperCardWrapper>
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
