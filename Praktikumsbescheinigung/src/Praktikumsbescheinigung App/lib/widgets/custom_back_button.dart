import 'package:flutter/material.dart';

import 'package:studybuddy/Screens/login_screen.dart';

class CustomBackButton extends StatefulWidget {
  CustomBackButton({
    Key key,
  }) : super(key: key);

  _BackButtonState createState() => _BackButtonState();
}

class _BackButtonState extends State<CustomBackButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 28.0,
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: _back,
        ),
    );
  }

  _back() {
    if(Navigator.canPop(context)) {
        Navigator.pop(context);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
    }
  }
}