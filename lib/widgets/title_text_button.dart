import 'package:detrack_pod_dl_app/constants.dart';
import 'package:flutter/material.dart';

/* --------------------------------------------------------------------------

Widget Title: Clickable Text Button
Widget Description: Widget for text button that requires a function and 
text to be passed to it

-----------------------------------------------------------------------------*/

class TitleTextButton extends StatelessWidget {
  final String buttonText;
  final Function pressedFunction;

  const TitleTextButton({
    required this.buttonText,
    required this.pressedFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {
          pressedFunction();
        },
        child: Text(
          buttonText,
          style: themeData.textTheme.headline5,
        ),
      ),
    );
  }
}
