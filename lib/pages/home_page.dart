import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/widgets/cool_swiper.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CoolSwiper(),
        ),
      ),
    );
  }
}
