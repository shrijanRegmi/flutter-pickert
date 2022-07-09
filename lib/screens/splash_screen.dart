import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/splash.json',
              width: MediaQuery.of(context).size.width / 1.5,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Pickert',
              style: TextStyle(
                fontSize: 52.0,
                color: Color(0xff302f35),
              ),
            ),
            Text(
              'Share love with the finest',
              style: TextStyle(
                color: Color(0xff302f35),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
