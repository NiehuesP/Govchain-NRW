import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class MenuButton extends StatefulWidget {
  MenuButton({
    Key key,
    this.scaffoldKey
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.fromLTRB(0.0, ResponsiveFlutter.of(context).verticalScale(32.0), ResponsiveFlutter.of(context).scale(16.0), 0.0),
      child: IconButton(
        iconSize: 32.0,
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          widget.scaffoldKey.currentState.openEndDrawer();
        },
      ),
    );
  }
}