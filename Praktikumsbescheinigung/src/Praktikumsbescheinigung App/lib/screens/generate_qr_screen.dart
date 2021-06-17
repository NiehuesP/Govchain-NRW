import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/objects/event_object.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/widgets/custom_back_button.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';

class GenerateQrScreen extends StatefulWidget {
  GenerateQrScreen({Key key, this.event}) : super(key: key);

  final EventObject event;

  _GenerateQrScreenState createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  String _prevPage;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    _prevPage = Globals.currentPage;
    Globals.currentPage = "generateQrScreen";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EventObject currentEvent = widget.event;
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: MenuDrawer(prevPage: _prevPage),
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
          Container(
            height: ResponsiveFlutter.of(context).hp(100),
            color: Color(0xff3f3d56),
          ),
          MenuButton(scaffoldKey: _scaffoldKey),
          Column(children: <Widget>[
            SizedBox(height: ResponsiveFlutter.of(context).verticalScale(32.0)),
            Row(children: <Widget>[
              CustomBackButton(),
              Container(
                padding: EdgeInsets.zero,
                alignment: Alignment.topLeft,
                child: Text(
                  'Praktikum',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: ResponsiveFlutter.of(context).fontSize(4.0), //fontSize: 24
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ]),
            SizedBox(
              height: ResponsiveFlutter.of(context).verticalScale(16.0),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: ResponsiveFlutter.of(context).scale(24.0)),
              alignment: Alignment.topLeft,
              child: Text(
                '${currentEvent.name} | ${currentEvent.date} ${currentEvent.time.split("-").first} Uhr',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                  color: const Color(0xff19d9d3),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: ResponsiveFlutter.of(context).verticalScale(48.0),
            ),
            Text(
                    'Schließen Sie Ihr Smartphone an ein \nprojektionsfähiges Gerät an.',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.0), //fontSize: 17
                      color: const Color(0xfffefeff),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ResponsiveFlutter.of(context).verticalScale(24.0),),
                  QrImage(
                    foregroundColor: Colors.white,
                    data: currentEvent.id.toString(),
                    version: QrVersions.auto,
                    size: ResponsiveFlutter.of(context).wp(70),
                  ),
          ],
          ),
        ],
        ),
    );
  }
}
