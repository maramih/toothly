import 'package:flutter/material.dart';
import 'package:toothly/screens/dashboard/menu_option.dart';
import 'package:toothly/shared/colors.dart';

class MenuOptionWidget extends StatelessWidget {
  final MenuOption option;
  final Function function;

  MenuOptionWidget({this.option,this.function});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15.0),
      child: InkWell(
        splashColor: Swatches.myPrimaryMint,
        onTap: () => function.call(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
 //               if(option.optionText.split("\n").length>1)
                Icon(option.iconData, color: Swatches.green1, size: 60.0),
                FittedBox(fit: BoxFit.fitHeight,
                    child: Text(option.optionText,softWrap: true,overflow: TextOverflow.ellipsis,maxLines: 2))
              ],
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ),
    );
  }
}
