import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/src/constants.dart';
import 'package:flutter_card_swiper/src/models/swiper_card.dart';
import 'package:flutter_card_swiper/src/widgets/cool_swiper_card.dart';
import 'package:flutter_card_swiper/src/widgets/cool_swiper_card_wrapper.dart';

class CoolSwiper extends StatefulWidget {
  final List<Widget> children;
  final double initAnimationOffset;
  final double cardHeight;

  const CoolSwiper({
    Key? key,
    required this.children,
    this.initAnimationOffset = Constants.initAnimationOffset,
    this.cardHeight = Constants.cardHeight,
  }) : super(key: key);

  @override
  State<CoolSwiper> createState() => _CoolSwiperState();
}

class _CoolSwiperState extends State<CoolSwiper>
    with SingleTickerProviderStateMixin {
  late final AnimationController backgroundCardsAnimationController;

  late final List<Widget> stackChildren;
  final ValueNotifier<bool> _backgroundCardsAreInFrontNotifier =
      ValueNotifier<bool>(false);
  bool fireBackgroundCardsAnimation = false;

  late final List<SwiperCard> _cards;

  List<Widget> get _stackChildren => List.generate(
        _cards.length,
        (i) {
          return CoolSwiperCard(
            key: ValueKey('__animated_card_${i}__'),
            card: _cards[i],
            height: widget.cardHeight,
            initAnimationOffset: widget.initAnimationOffset,
            onAnimationTrigger: _onAnimationTrigger,
            onVerticalDragEnd: () {},
          );
        },
      );

  void _onAnimationTrigger() async {
    setState(() {
      fireBackgroundCardsAnimation = true;
    });
    backgroundCardsAnimationController.forward();
    Future.delayed(Constants.backgroundCardsAnimationDuration).then(
      (_) {
        _backgroundCardsAreInFrontNotifier.value = true;
      },
    );
    Future.delayed(Constants.swipeAnimationDuration).then(
      (_) {
        _backgroundCardsAreInFrontNotifier.value = false;
        backgroundCardsAnimationController.reset();
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
    _cards = SwiperCard.listFromWidgets(widget.children);
    stackChildren = _stackChildren;

    backgroundCardsAnimationController = AnimationController(
      vsync: this,
      duration: Constants.backgroundCardsAnimationDuration,
    );
  }

  @override
  void dispose() {
    backgroundCardsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: _backgroundCardsAreInFrontNotifier,
          builder: (c, bool backgroundCardsAreInFront, _) =>
              backgroundCardsAreInFront
                  ? Positioned(child: Container())
                  : _buildBackgroundCardsStack(),
        ),
        _buildFrontCard(),
        ValueListenableBuilder(
          valueListenable: _backgroundCardsAreInFrontNotifier,
          builder: (c, bool backgroundCardsAreInFront, _) =>
              backgroundCardsAreInFront
                  ? _buildBackgroundCardsStack()
                  : Positioned(child: Container()),
        ),
      ],
    );
  }

  Widget _buildBackgroundCardsStack() {
    return Stack(
      children: List.generate(
        _cards.length - 1,
        (i) => _buildStackChild(i),
      ),
    );
  }

  Widget _buildFrontCard() {
    return _buildStackChild(_cards.length - 1);
  }

  Widget _buildStackChild(int i) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: i != stackChildren.length - 1,
        child: CoolSwiperCardWrapper(
          animationController: backgroundCardsAnimationController,
          initialScale: _cards[i].scale,
          initialYOffset: _cards[i].yOffset,
          child: stackChildren[i],
        ),
      ),
    );
  }
}
