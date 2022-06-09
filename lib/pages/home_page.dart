import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/constants.dart';
import 'package:flutter_card_swiper/data.dart';
import 'package:flutter_card_swiper/widgets/cool_swiper.dart';

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
              (index) => Container(
                height: Constants.cardHeight,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Data.colors[index],
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
