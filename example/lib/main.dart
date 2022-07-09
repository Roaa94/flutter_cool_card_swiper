import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cool_card_swiper/cool_card_swiper_config.dart';
import 'package:flutter_cool_card_swiper/flutter_cool_card_swiper.dart';

void main() {
  runApp(const MyApp());
}

List<Color> colors = [
  Colors.red.shade300,
  Colors.yellow.shade200,
  Colors.blue.shade300,
  Colors.white,
];

const double cardHeight = 220;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: CoolCardSwiper(
              config: CoolCardSwiperConfig(
                height: cardHeight,
                animationStartDistance: 100,
              ),
              children: List.generate(
                colors.length,
                (index) => CardContent(color: colors[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final Color color;

  const CardContent({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 15,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 15,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
