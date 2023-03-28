import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

import 'home_screen.dart';


class SplachScreen extends StatelessWidget {
  const SplachScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasySplashScreen(
        logo: Image.asset("assets/xo.jpg"),

        logoWidth: 70,
        title: Text(
          "Tic Tac Toe",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        showLoader: true,
        loaderColor: Colors.white,
        loadingText: Text("Loading ..."),
        navigator: HomePage(),
        durationInSeconds: 5,
      ),
    );
  }
}
