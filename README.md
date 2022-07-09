# Flutter Cool Card Swiper

Inspired by [the original Swift UI implementation](https://twitter.com/philipcdavis/status/1534192823792128000) by [@philipcdavis](https://twitter.com/philipcdavis) 

🛠 [Live preview & tincker with the code in this DartPad](https://dartpad.dev/5734add617929fd7448740d7ce16ae0c) 🛠 

### This is how it looks

https://user-images.githubusercontent.com/50345358/172962639-89ac3578-2344-4a15-8ed6-dfac772de8b7.mp4

# Details

There are a few elements in this animation

1. Cards stacked behind each other, the card’s scale & y position depend on their order (index) in the stack.
2. When the user touches/clicks on the front card and holds, the card rotates a small angle, the center of that angle is relative to the pointer location (top-left/top-right/bottom-left/bottom-right), and the direction of the angle is based on the pointer location side (left => angle is positive, right => angle is negative)
3. When the user starts dragging, the card moves with the poitner on the y-axis
4. When the user releases, if the card travelled an `initAnimationOffset` distance, the main animation is triggerred, which is:
    1. Slide up a `throwSlideYDistance` & start full rotation (the rotation direction also depends on the pointer location like the animation in step 2)
    2. While rotating, slide down into the position of the furthest card in the stack
    3. Throughout the animation, scale down to scale of the furthest card in the stack
    4. The background cards scale up and slide down to replace the positioning of the animating card
5. ⚠️ THE MAIN CATCH ⚠️ A short duration after the animation starts, a callback allows the parent stack to switch the location of the background cards (the cards that aren't animating) from being behind the animating card in the z-axis, to being in-front of it. This happens when the card is "in the air" so that when it lands back in the stack, it lands behind the other cards. 

To achieve the above, the following widgets were used:
1. Main `Stack` widget containing the cards
2. `GestureDetector` widget that handles user drag input and starts animations accordingly with the methods:
    1. `onVerticalDragStart` (step 2 & 3 above)
    2. `onVerticalDragUpdate` (step 3 above)
    3. `onVerticalDragEnd` (step 4 & 5 above)
3. A combination of animation widgets like `TweenAnimationBuilder`, `AnimatedBuilder`, `AnimatedRotation`, `Transform.translate`, `Transform.rotate`, `Transform.scale` to achieve the animations.
4. `IgnorePointer` to allow touching/clicking on the forefront card only.
5. A `ValueListenableBuilder` & `ValueNotifier` combination to rebuild only parts of the parent `Stack` widget without causing a rebuild of the widget being animated and thus resetting that animation half-way and not allowing it to complete. You can see this in this code snippet (the build method of the main `CoolSwiper` widget

```dart
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
      // The goal is not to rebuild this widget when the widgets around it ar swapped
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
```

Then these notifiers are updated in this function, which is called inside the `onVerticalDragEnd` in the card widget:

```dart
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
```

