import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/constants.dart';

class SwiperCard extends Equatable {
  final Color color;
  final int order;
  final double scale;
  final double yOffset;

  const SwiperCard({
    required this.color,
    required this.order,
  })  : scale = 1 - (order * Constants.scaleFraction),
        yOffset = order * Constants.yOffset;

  @override
  List<Object?> get props => [
        color,
        order,
      ];
}
