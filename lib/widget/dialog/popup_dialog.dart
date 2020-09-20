import 'package:beans/generated/r.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  final String message;
  final String image;
  final Function onDimiss;

  PopupDialog({this.message, this.image, this.onDimiss});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 200.0,
        width: 286.0,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Spacer(),
                CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    R.ic_close_gradient,
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 1, left: 1),
              child: Image.asset(
                image,
                width: 62,
                height: 54,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xff0370a4),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Montserrat",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
