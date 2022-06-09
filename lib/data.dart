import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/models/animated_card.dart';

class Data {
  static List<Color> colors = [
    Colors.blue.shade300,
    Colors.red.shade300,
    Colors.green.shade300,
    Colors.purple.shade300,
    Colors.yellow.shade300,
    Colors.pink.shade200,
  ];

  static List<AnimatedCard> cards = [
    // ...backCards,
    ...frontCards,
  ];

  static List<AnimatedCard> frontCards = List.generate(
    colors.length,
    (index) => AnimatedCard(
      color: colors[index],
      order: index,
    ),
  ).reversed.toList();

  static List<AnimatedCard> backCards = List.generate(
    colors.length,
    (index) => AnimatedCard(
      color: colors[index],
      order: index,
      isMirror: true,
    ),
  );
}
