
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/Contatori/touch_counter.dart';

class NavigationHome extends StatelessWidget {
  const NavigationHome({super.key});

  @override
  Widget build(BuildContext context) {
    void incrementTouchCount() {
      Provider.of<TouchController>(context, listen: false).incrementTouches();
    }

    return Container(
      color: Colors.transparent,
      height: 90,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: incrementTouchCount,
            child: IconButton(
              icon: const Icon(
                Icons.star,
                size: 36.0,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/classifica');
              },
            ),
          ),
          GestureDetector(
            onTap: incrementTouchCount,
            child: IconButton(
              icon: const Icon(
                Icons.rocket,
                size: 36.0,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/scrollMeter');
              },
            ),
          ),
          GestureDetector(
            onTap: incrementTouchCount,
            child: IconButton(
              icon: const Icon(
                Icons.person_3,
                size: 36.0,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
        ],
      ),
    );
  }
}
