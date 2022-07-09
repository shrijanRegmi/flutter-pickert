import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:imhotep/viewmodels/app_vm.dart';
import 'package:imhotep/wrapper.dart';
import 'package:imhotep/wrapper_builder.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_live_51HBKxDHjFEGleUf9NWFBHNjeShc5Chm3yVbsLVosFEF8OBOl3GZCqBLrVxACEoLZgLCpeuWNNZ93QTYEijZA0GVb00TcCidHU3';
  MobileAds.instance.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xff302f35),
      systemNavigationBarColor: Color(0xff302f35),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  await Peaman.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppVm>(
          create: (_) => AppVm(),
        ),
        StreamProvider<PeamanUser?>(
          create: (_) => PAuthProvider.user,
          initialData: null,
        )
      ],
      builder: (context, child) {
        return WrapperBuilder(
          builder: (context) {
            return MaterialApp(
              title: 'Pickert',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: GoogleFonts.nunito(
                  color: Color(0xff302f35),
                ).fontFamily,
                primarySwatch: Colors.blue,
              ),
              home: Wrapper(),
            );
          },
        );
      },
    );
  }
}
