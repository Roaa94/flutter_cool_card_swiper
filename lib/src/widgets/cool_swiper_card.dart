import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants.dart';
import '../../cool_card_swiper_config.dart';
import '../swiper_card.dart';

/// This is the widget responsible for user drag & release animations
///
/// It also sends drag information to root stack widget
class CoolSwiperCard extends StatefulWidget {
  const CoolSwiperCard({
    Key? key,
    required this.card,
    required this.onAnimationTrigger,
    required this.onVerticalDragEnd,
    this.config = const CoolCardSwiperConfig(),
  }) : super(key: key);

  final SwiperCard card;
  final Function onAnimationTrigger;
  final Function onVerticalDragEnd;
  final CoolCardSwiperConfig config;

  @override
  State<CoolSwiperCard> createState() => _CoolSwiperCardState();
}

class _CoolSwiperCardState extends State<CoolSwiperCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  late final Animation<double> rotationAnimation;
  late final Animation<double> slideUpAnimation;
  late final Animation<double> slideDownAnimation;
  late final Animation<double> scaleAnimation;

  Tween<double> rotationAnimationTween = Tween<double>(begin: 0, end: -360);
  Tween<double> slideDownAnimationTween = Tween<double>(begin: 0, end: 0);

  double yDragOffset = 0;
  double dragStartAngle = 0;
  Alignment dragStartRotationAlignment = Alignment.centerRight;
  Duration dragDuration = const Duration(milliseconds: 0);

  /// When the drag starts, the card rotates a small angle
  /// with an alignment based on the touch/click location of the user
  ///
  /// And the main flying rotation tween gets its end value based on the
  /// touch/click location as well to determine whether the flying flip will
  /// happen with a negative or positive angle
  void _onVerticalDragStart(DragStartDetails details) {
    double screenWidth = MediaQuery.of(context).size.width;

    final xPosition = details.globalPosition.dx;
    final yPosition = details.localPosition.dy;
    final angleMultiplier = xPosition > screenWidth / 2 ? -1 : 1;
    rotationAnimationTween.end =
        Constants.rotationAnimationAngleDeg * angleMultiplier;

    // Update values of the small angle drag start rotation animation
    setState(() {
      dragStartRotationAlignment = widget.config.getDragStartPositionAlignment(
        xPosition,
        yPosition,
        screenWidth,
      );
      dragStartAngle = Constants.dragStartEndAngle * angleMultiplier;
      // If the drag duration is larger than zero, rest to zero
      // to allow the card to move with user finger/mouse smoothly
      if (dragDuration > Duration.zero) {
        dragDuration = Duration.zero;
      }
    });
  }

  /// When the drag ends, first a check is made to ensure the card travelled some
  /// offset distance upwards,
  /// if it didn't, the cards returns to place
  /// if it did, the animation is triggered by
  ///   - calling a callback to the parent widget
  ///   - changing the end value of the slide down animation tween
  ///     based on how much distance the card travelled
  ///   - calling forward() on the animation controller
  ///
  /// After the animation finishes, a callback to the parent widget is
  /// called to let it know that it can swap the background cards and brings
  /// them forward to reset the indices and allow for the next card to be dragged & animated
  void _onVerticalDragEnd(DragEndDetails details) {
    if ((yDragOffset * -1) > widget.config.animationStartDistance) {
      widget.onAnimationTrigger();
      slideDownAnimationTween.end = Constants.throwSlideYDistance +
          yDragOffset.abs() -
          (widget.card.totalCount - 1) * Constants.yOffset;

      animationController.forward().then((value) {
        widget.onVerticalDragEnd();
        setState(() {
          dragStartAngle = 0;
        });
      });
    } else {
      setState(() {
        // Set a non-zero drag rotation to allow the card to reset to original
        // position smoothly rather than snapping back into place
        dragDuration = const Duration(milliseconds: 200);
        yDragOffset = 0;
        dragStartAngle = 0;
      });
    }
  }

  /// This moves the card with user touch/click & hold
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      yDragOffset += details.delta.dy;
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Constants.swipeAnimationDuration,
    );

    rotationAnimation = rotationAnimationTween.animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    scaleAnimation = Tween<double>(
      begin: 1,
      end: 1 - ((widget.card.totalCount - 1) * Constants.scaleFraction),
    ).animate(animationController);

    // Staggered animation is used here to allow
    // sequencing the slide up & slide down animations
    slideUpAnimation = Tween<double>(
      begin: 0,
      end: -Constants.throwSlideYDistance,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0, 0.5, curve: Curves.linear),
    ));

    slideDownAnimation = slideDownAnimationTween.animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.5, 1, curve: Curves.linear),
    ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: yDragOffset),
        duration: dragDuration,
        curve: Curves.easeOut,
        // This TweenAnimationBuilder widget is responsible for the user
        // touch/click & hold dragging
        // Or the DRAG UPDATE ANIMATION
        builder: (c, double value, child) => Transform.translate(
          offset: Offset(0, value),
          child: child,
        ),
        child: AnimatedBuilder(
          animation: animationController,
          // This widgets is responsible for the small angle rotation
          // triggered on user touch/click & hold
          // Or the DRAG START ANIMATION
          child: AnimatedRotation(
            turns: dragStartAngle,
            alignment: dragStartRotationAlignment,
            duration: const Duration(milliseconds: 200),
            child: widget.card.child,
          ),
          builder: (c, child) {
            // This widgets inside the builder method of the AnimatedBuilder
            // widget are responsible for the:
            // slide-up => rotation => slide-down animations
            // Or the DRAG END ANIMATION
            return Transform.translate(
              // slide up some distance beyond drag location
              offset: Offset(0, slideUpAnimation.value),
              child: Transform.translate(
                // slide down into place
                offset: Offset(0, slideDownAnimation.value),
                child: Transform.rotate(
                  // rotate
                  angle: rotationAnimation.value * (math.pi / 180),
                  alignment: Alignment.center,
                  child: Transform.scale(
                    // Scale down to scale of the smallest card in stack
                    scale: scaleAnimation.value,
                    child: child,
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
