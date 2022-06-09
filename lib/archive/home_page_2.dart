import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/constants.dart';
import 'package:flutter_card_swiper/data.dart';
import 'package:flutter_card_swiper/models/animated_card.dart';
import 'package:flutter_card_swiper/archive/animated_card_item_2.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Map<int, double> yDragOffsets = {};
  Map<int, double> rotations = {};
  int frontCardIndex = Data.cards.length - 1;
  Duration swipeAnimationDuration = Duration.zero;

  setYDragOffsets(int i, double dy) {
    int mirrorItemIndex = (Data.cards.length - 1) - i;
    setState(() {
      yDragOffsets[i] = (yDragOffsets[i] ?? 0) + dy;
      yDragOffsets[mirrorItemIndex] = (yDragOffsets[mirrorItemIndex] ?? 0) + dy;
    });
  }

  setRotations(int i) {
    int mirrorItemIndex = (Data.cards.length - 1) - i;
    setState(() {
      rotations[i] = -1;
      rotations[mirrorItemIndex] = -1;
    });
  }

  resetRotations(int i) {
    int mirrorItemIndex = (Data.cards.length - 1) - i;
    setState(() {
      rotations[i] = 0;
      rotations[mirrorItemIndex] = 0;
    });
  }

  resetYDragOffsets(int i) {
    int mirrorItemIndex = (Data.cards.length - 1) - i;
    setState(() {
      yDragOffsets[i] = 0;
      yDragOffsets[mirrorItemIndex] = 0;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            clipBehavior: Clip.none,
            children: List.generate(
              Data.cards.length,
              (i) {
                final AnimatedCard card = Data.cards[i];

                return AnimatedPositioned(
                  duration: swipeAnimationDuration,
                  bottom: (card.yOffset - (yDragOffsets[i] ?? 0)),
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    // ignoring: i != frontCardIndex,
                    ignoring: false,
                    child: Transform.scale(
                      scale: card.scale,
                      child: AnimatedRotation(
                        duration: swipeAnimationDuration,
                        turns: rotations[i] ?? 0,
                        child: AnimatedCardItem(
                          key: ValueKey('__animated_card_${i}__'),
                          card: Data.cards[i],
                          onVerticalDragStart: () {},
                          yDragOffsets: yDragOffsets,
                          onVerticalDragEnd: () {
                            if (swipeAnimationDuration == Duration.zero) {
                              setState(() {
                                swipeAnimationDuration =
                                    Constants.swipeAnimationDuration;
                              });
                            }
                            if (yDragOffsets[i] != null &&
                                yDragOffsets[i]!.abs() >
                                    Constants.initAnimationOffset) {
                              setRotations(i);
                              resetYDragOffsets(i);
                              Future.delayed(Constants.swipeAnimationDuration)
                                  .then((value) {
                                setState(() {
                                  swipeAnimationDuration = Duration.zero;
                                });
                                resetRotations(i);
                              });
                            } else {
                              setState(() {
                                swipeAnimationDuration =
                                    const Duration(milliseconds: 200);
                              });
                              resetYDragOffsets(i);
                              Future.delayed(const Duration(milliseconds: 200))
                                  .then((value) {
                                setState(() {
                                  swipeAnimationDuration = Duration.zero;
                                });
                              });
                            }
                          },
                          onVerticalDragUpdate: (double dy) {
                            setYDragOffsets(i, dy);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
