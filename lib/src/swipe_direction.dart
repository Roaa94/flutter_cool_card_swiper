enum SwipeDirection {
  upwards,
  downwards;

  double get multiplier {
    switch (this) {
      case SwipeDirection.downwards:
        return 1;
      case SwipeDirection.upwards:
        return -1;
    }
  }

  double get multiplierReversed {
    switch (this) {
      case SwipeDirection.downwards:
        return -1;
      case SwipeDirection.upwards:
        return 1;
    }
  }
}
