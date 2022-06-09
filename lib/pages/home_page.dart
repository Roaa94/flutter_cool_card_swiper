import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/data.dart';
import 'package:flutter_card_swiper/widgets/card_content.dart';
import 'package:flutter_card_swiper/src/widgets/cool_swiper.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CoolSwiper(
            children: List.generate(
              Data.colors.length,
              (index) => CardContent(color: Data.colors[index]),
            ),
          ),
        ),
      ),
    );
  }
}
