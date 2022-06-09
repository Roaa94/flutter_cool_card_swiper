import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/constants.dart';

class AnimatedCard extends Equatable {
  final Color color;
  int order;
  double scale;
  double yOffset;
  bool isMirror;

  AnimatedCard({
    required this.color,
    required this.order,
    this.isMirror = false,
  })  : scale = 1 - (order * Constants.scaleFraction),
        yOffset = order * Constants.yOffset;

  @override
  List<Object?> get props => [
        color,
        order,
      ];
}
