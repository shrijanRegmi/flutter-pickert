import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  final Color color;
  const Spinner({
    Key? key,
    this.color = const Color(0xff302f35),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        color: color,
      ),
    );
  }
}
