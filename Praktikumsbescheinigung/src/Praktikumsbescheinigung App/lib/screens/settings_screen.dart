import 'package:flutter/material.dart';
import 'package:studybuddy/services/globals.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({
    Key key,
  }) : super(key: key);


  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    Globals.currentPage = "settingsScreen";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Placeholder",
          style: TextStyle(
            fontSize: 32.0,
            color: Colors.black,
        ),
        ),
      ),
    );
  }
}
