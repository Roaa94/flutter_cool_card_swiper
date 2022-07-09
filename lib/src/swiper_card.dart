import 'package:flutter/material.dart';

import 'constants.dart';

class SwiperCard {
  final int order;
  final double scale;
  final Widget child;
  final int totalCount;

  const SwiperCard({
    required this.order,
    required this.child,
    required this.totalCount,
  })  : scale = 1 - (order * Constants.scaleFraction);

  static List<SwiperCard> listFromWidgets(List<Widget> children) {
    return List.generate(
      children.length,
      (i) => SwiperCard(
        order: i,
        child: children[i],
        totalCount: children.length,
      ),
    ).reversed.toList();
  }
}
