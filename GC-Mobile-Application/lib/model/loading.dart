import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.deepOrange,
          size: 50.0,
        ),
      ),
    );
  }
}

class Loading2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.deepOrange,
          size: 50.0,
        ),
      ),
    );
  }
}