import 'package:flutter/material.dart';
import 'package:toothly/screens/dashboard/menu_option.dart';
import 'package:toothly/shared/colors.dart';

class MenuOptionWidget extends StatelessWidget {
  final MenuOption option;

  MenuOptionWidget({this.option});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15.0),
      child: InkWell(
        splashColor: Swatches.myPrimaryMint,
        onTap: () => print(option.toString()),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Icon(option.iconData, color: Swatches.green1, size: 60.0),
                FittedBox(fit: BoxFit.fitWidth, child: Text(option.optionText))
              ],
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ),
    );
  }
}
