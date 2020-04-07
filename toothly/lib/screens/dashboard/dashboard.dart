import 'package:flutter/material.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      backgroundColor: Swatches.mySecondaryMint,
      body: Center(
        child: Text("DASH ME"),
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}
