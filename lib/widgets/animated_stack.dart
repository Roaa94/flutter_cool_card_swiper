import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/constants.dart';
import 'package:flutter_card_swiper/data.dart';
import 'package:flutter_card_swiper/models/animated_card.dart';
import 'package:flutter_card_swiper/widgets/animated_card_item.dart';
import 'package:flutter_card_swiper/widgets/animated_card_wrapper.dart';

class AnimatedStack extends StatefulWidget {
  const AnimatedStack({Key? key}) : super(key: key);

  @override
  State<AnimatedStack> createState() => _AnimatedStackState();
}

class _AnimatedStackState extends State<AnimatedStack> {
  late final List<Widget> stackChildren;
  final ValueNotifier<bool> flipNotifier = ValueNotifier<bool>(true);
  bool fireBackgroundCardsAnimation = false;

  // late Map<int, double> scales = {};
  // late Map<int, double> yOffsets = {};

  List<Widget> get _stackChildren => List.generate(
    Data.cards.length,
        (i) {
      final AnimatedCard card = Data.cards[i];

      return AnimatedCardItem(
        key: ValueKey('__animated_card_${i}__'),
        card: card,
        onAnimationTrigger: _onAnimationTrigger,
        onVerticalDragEnd: _onVerticalDragEnd,
      );
    },
  );

  void _onAnimationTrigger() async {
    setState(() {
      fireBackgroundCardsAnimation = true;
    });
    await Future.delayed(Constants.backgroundCardsAnimationDuration);
    flipNotifier.value = false;
  }

  void _onVerticalDragEnd() async {
    await Future.delayed(Constants.swipeAnimationDuration);
    flipNotifier.value = true;
    _swapLast();
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
        getFrontCard(),
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
            (i) => stackChild(i),
      ),
    );
  }

  Widget getFrontCard() {
    return stackChild(Data.cards.length - 1);
  }

  Widget stackChild(int i) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: i != stackChildren.length - 1,
        child: AnimatedCardWrapper(
          initialScale: Data.cards[i].scale,
          initialYOffset: Data.cards[i].yOffset,
          child: stackChildren[i],
        ),
      ),
    );
  }
}
