import 'package:fingerfy/Providers/Contatori/touch_counter.dart';
import 'package:fingerfy/Views/profilo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({super.key});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  void _incrementTouchCount() {
    Provider.of<TouchCounter>(context, listen: false).incrementTouches();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(right: 50),
      child: GestureDetector(
        onTap: _incrementTouchCount,
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(userID: ''),
              ),
            );
          },
          icon: const Icon(
            Icons.person_3,
            size: 36.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
