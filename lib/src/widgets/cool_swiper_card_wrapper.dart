import 'package:flutter/material.dart';

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
  final AnimationController animationController;

  const CoolSwiperCardWrapper({
    Key? key,
    required this.child,
    this.initialScale = 1,
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

    scaleAnimation = Tween<double>(
      begin: widget.initialScale,
      end: widget.initialScale + 0.05,
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
        alignment: const Alignment(0, -2.3),
        scale: scaleAnimation.value,
        child: child,
      ),
      child: widget.child,
    );
  }
}
