import 'package:flutter/material.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';

class SettingsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      backgroundColor: Swatches.mySecondaryMint,
      body: Center(
        child: Text("LogOut\nPrivacyPolicy\nAbout the clinic\nChange password\nPermissions"),
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}
