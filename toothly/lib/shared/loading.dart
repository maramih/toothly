import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toothly/shared/colors.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:Swatches.mySecondaryMint,
      child: Center(
        child: SpinKitCubeGrid(
          color: Swatches.myPrimaryMint,
          size: 100.0,
        ),
      ),
    );
  }
}
