import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/constants.dart';
import 'package:flutter_card_swiper/models/animated_card.dart';
import 'package:flutter_card_swiper/utils.dart';

class AnimatedCardItem extends StatefulWidget {
  final AnimatedCard card;
  final Function onVerticalDragStart;
  final Function onVerticalDragEnd;
  final ValueChanged<double> onVerticalDragUpdate;
  final Map<int, double> yDragOffsets;

  const AnimatedCardItem({
    Key? key,
    required this.card,
    required this.onVerticalDragStart,
    required this.onVerticalDragEnd,
    required this.onVerticalDragUpdate,
    required this.yDragOffsets,
  }) : super(key: key);

  @override
  State<AnimatedCardItem> createState() => _CardState();
}

class _CardState extends State<AnimatedCardItem> with SingleTickerProviderStateMixin {
  // late final AnimationController animationController;
  // late final Animation<double> flyingRotationAnimation;

  double dragStartAngle = 0;
  Alignment dragStartRotationAlignment = Alignment.centerRight;

  @override
  void initState() {
    super.initState();
    // animationController = AnimationController(
    //   vsync: this,
    //   duration: Constants.swipeAnimationDuration,
    // );

    // flyingRotationAnimation = Tween<double>(
    //   begin: 0,
    //   end: 1,
    // ).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // print('Rebuilt card: ${widget.card.order}');

    return GestureDetector(
      onVerticalDragStart: (DragStartDetails details) {
        final xPosition = details.globalPosition.dx;
        final yPosition = details.localPosition.dy;
        // print('drag start global x position & local y positions [$xPosition, $yPosition]');

        setState(() {
          dragStartRotationAlignment = getDragStartPositionAlignment(
            xPosition,
            yPosition,
            screenWidth,
            Constants.cardHeight,
          );
          dragStartAngle = Constants.dragStartEndAngle *
              (xPosition > screenWidth / 2 ? -1 : 1);
        });
        widget.onVerticalDragStart();
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        widget.onVerticalDragUpdate(details.delta.dy);
      },
      onVerticalDragEnd: (DragEndDetails details) {
        widget.onVerticalDragEnd();
        setState(() {
          dragStartAngle = 0;
        });
      },
      child: AnimatedRotation(
        turns: dragStartAngle,
        alignment: dragStartRotationAlignment,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: Constants.cardHeight,
          decoration: BoxDecoration(
            color: widget.card.color,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              '${widget.card.order}',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
