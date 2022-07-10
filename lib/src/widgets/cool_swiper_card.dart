import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../cool_card_swiper_config.dart';

/// This is the widget responsible for user drag & release animations
///
/// It also sends drag information to root stack widget
class CoolSwiperCard extends StatefulWidget {
  const CoolSwiperCard({
    Key? key,
    required this.child,
    required this.cardsCount,
    required this.onAnimationTrigger,
    required this.config,
    required this.index,
  }) : super(key: key);

  final Widget child;
  final int cardsCount;
  final int index;

  /// Callback to trigger animation logic in the parent stack
  final Function onAnimationTrigger;

  final CoolCardSwiperConfig config;

  @override
  State<CoolSwiperCard> createState() => _CoolSwiperCardState();
}

class _CoolSwiperCardState extends State<CoolSwiperCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  late final Animation<double> rotationAnimation;
  late final Animation<double> slideFurtherAnimation;
  late final Animation<double> slideBackAnimation;
  late final Animation<double> scaleAnimation;

  Tween<double> rotationAnimationTween = Tween<double>(begin: 0, end: -360);
  Tween<double> slideBackAnimationTween = Tween<double>(begin: 0, end: 0);

  double yDragOffset = 0;
  double onTapRotationTurns = 0;
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
    rotationAnimationTween.end = widget.config.turns * 360.0 * angleMultiplier;

    // Update values of the small angle drag start rotation animation
    setState(() {
      dragStartRotationAlignment = widget.config.getDragStartPositionAlignment(
        xPosition,
        yPosition,
        screenWidth,
      );
      onTapRotationTurns =
          (widget.config.onTapRotationAngle / 360) * angleMultiplier;

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
    if ((yDragOffset * widget.config.direction.multiplier) >
        widget.config.animationStartDistance) {
      widget.onAnimationTrigger();
      slideBackAnimationTween.end =
          (widget.config.throwDistanceOnDragEnd + yDragOffset.abs()) *
              widget.config.direction.multiplierReversed;
      animationController.forward().then((value) {
        setState(() {
          onTapRotationTurns = 0;
        });
      });
    } else {
      setState(() {
        // Set a non-zero drag rotation to allow the card to reset to original
        // position smoothly rather than snapping back into place
        dragDuration = const Duration(milliseconds: 200);
        yDragOffset = 0;
        onTapRotationTurns = 0;
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
      duration: widget.config.swipeAnimationDuration,
    );

    rotationAnimation = rotationAnimationTween.animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    scaleAnimation = Tween<double>(
      begin: 1,
      end: widget.config.minCardScaleFraction,
    ).animate(animationController);

    // Staggered animation is used here to allow
    // sequencing the slide further & slide back animations
    slideFurtherAnimation = Tween<double>(
      begin: 0,
      end: widget.config.throwDistanceOnDragEnd *
          widget.config.direction.multiplier,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0, 0.5, curve: Curves.linear),
    ));

    slideBackAnimation = slideBackAnimationTween.animate(CurvedAnimation(
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
            key: Key('__small_angle_rotation_widget_${widget.index}__'),
            turns: onTapRotationTurns,
            alignment: dragStartRotationAlignment,
            duration: widget.config.smallAngleRotationDuration,
            child: widget.child,
          ),
          builder: (c, child) {
            // This widgets inside the builder method of the AnimatedBuilder
            // widget are responsible for the:
            // slide-up => rotation => slide-down animations
            // Or the DRAG END ANIMATION
            return Transform.translate(
              // slide up some distance beyond drag location
              offset: Offset(0, slideFurtherAnimation.value),
              child: Transform.translate(
                // slide down into place
                offset: Offset(0, slideBackAnimation.value),
                child: Transform.rotate(
                  // rotate
                  key: Key('__swipe_rotation_animation_${widget.index}__'),
                  angle: rotationAnimation.value * (math.pi / 180),
                  alignment: Alignment.center,
                  child: Transform.scale(
                    // Scale down to scale of the smallest card in stack
                    key: Key('__swipe_scale_animation_${widget.index}__'),
                    scale: scaleAnimation.value,
                    alignment: widget.config.cardsScaleOriginAlignment,
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
