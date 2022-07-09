import 'package:flutter/material.dart';
import 'package:imhotep/screens/auth_screen.dart';
import 'package:imhotep/screens/home_screen.dart';
import 'package:imhotep/screens/splash_screen.dart';
import 'package:imhotep/sign_up/sign_up.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 6000), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser?>();
    if (_loading) return SplashScreen();
    if (_appUser != null && _appUser.name == null) return SignUp();
    if (_appUser != null && _appUser.uid != null) return HomeScreen();
    return AuthScreen();
  }
}
