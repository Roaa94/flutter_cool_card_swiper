import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/constants.dart';
import 'package:flutter_card_swiper/data.dart';
import 'package:flutter_card_swiper/widgets/animated_card_item.dart';
import 'package:flutter_card_swiper/widgets/animated_card_wrapper.dart';

class AnimatedStack extends StatefulWidget {
  const AnimatedStack({Key? key}) : super(key: key);

  @override
  State<AnimatedStack> createState() => _AnimatedStackState();
}

class _AnimatedStackState extends State<AnimatedStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController backgroundCardsanimationController;

  late final List<Widget> stackChildren;
  final ValueNotifier<bool> flipNotifier = ValueNotifier<bool>(true);
  bool fireBackgroundCardsAnimation = false;

  List<Widget> get _stackChildren => List.generate(
        Data.cards.length,
        (i) {
          return AnimatedCardItem(
            key: ValueKey('__animated_card_${i}__'),
            card: Data.cards[i],
            onAnimationTrigger: _onAnimationTrigger,
            onVerticalDragEnd: () {},
          );
        },
      );

  void _onAnimationTrigger() async {
    setState(() {
      fireBackgroundCardsAnimation = true;
    });
    backgroundCardsanimationController.forward();
    Future.delayed(Constants.backgroundCardsAnimationDuration).then(
      (_) {
        flipNotifier.value = false;
      },
    );
    Future.delayed(Constants.swipeAnimationDuration).then(
      (_) {
        flipNotifier.value = true;
        backgroundCardsanimationController.reset();
        _swapLast();
      },
    );
  }

  void _swapLast() {
    Widget last = stackChildren[stackChildren.length - 1];

    setState(() {
      stackChildren.removeLast();
      stackChildren.insert(0, last);
    });
  }

  @override
  void initState() {
    super.initState();
    stackChildren = _stackChildren;

    backgroundCardsanimationController = AnimationController(
      vsync: this,
      duration: Constants.backgroundCardsAnimationDuration,
    );
  }

  @override
  void dispose() {
    backgroundCardsanimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: flipNotifier,
          builder: (c, bool flip, _) => flip
              ? _buildBackgroundCardsStack()
              : Positioned(child: Container()),
        ),
        _buildFrontCard(),
        ValueListenableBuilder(
          valueListenable: flipNotifier,
          builder: (c, bool flip, _) => flip
              ? Positioned(child: Container())
              : _buildBackgroundCardsStack(),
        ),
      ],
    );
  }

  Widget _buildBackgroundCardsStack() {
    return Stack(
      children: List.generate(
        Data.cards.length - 1,
        (i) => _buildStackChild(i),
      ),
    );
  }

  Widget _buildFrontCard() {
    return _buildStackChild(Data.cards.length - 1);
  }

  Widget _buildStackChild(int i) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: i != stackChildren.length - 1,
        child: AnimatedCardWrapper(
          animationController: backgroundCardsanimationController,
          initialScale: Data.cards[i].scale,
          initialYOffset: Data.cards[i].yOffset,
          child: stackChildren[i],
        ),
      ),
    );
  }
}
