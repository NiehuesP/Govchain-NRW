import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/objects/event_object.dart';
import 'package:studybuddy/objects/event_settings_object.dart';
import 'package:studybuddy/objects/student_event_object.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/services/web_service.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';
import 'complete_attestation_screen.dart';
import 'upload_file_screen.dart';

class ScanQrScreen extends StatefulWidget {
  ScanQrScreen({
    Key key,
  }) : super(key: key);

  @override
  _ScanQrScreenState createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  String barcode = "";
  DatabaseService dbService = DatabaseService.instance;
  WebService webService = WebService.instance;
  String _prevPage;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  Future _scan() async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      setState(() => this.barcode = result.rawContent);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
          _buildErrorDialog(context, barcode);
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
        _buildErrorDialog(context, barcode);
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
      _buildErrorDialog(context, barcode);
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
      _buildErrorDialog(context, barcode);
    }
    if(barcode.isEmpty) {
      return;
    }
    print(barcode);
    EventObject eventObject = await dbService.getEventById(int.parse(barcode));
    if(eventObject != null) {
      Globals.currentEvent = eventObject;
      Globals.currentCourse = await dbService.getCourseById(eventObject.courseId);
      StudentEventObject studentEvent = await dbService.getStudentEventById(Globals.currentUser.id, eventObject.id);
      EventSettingsObject eventSettings = await dbService.getEventSettingsById(eventObject.id, Globals.currentCourse.professorId);
      print(eventObject.id);
      print(Globals.currentCourse);
      print(Globals.currentCourse.professorId);
      print(studentEvent);
      print(eventSettings);
      //TODO: do event settings calculations serverside
      String prevPage = Globals.currentPage;

      if(studentEvent.status == "waiting") {
        if(eventSettings.needUpload == false && eventSettings.autoComplete == true) {
          DateTime now = DateTime.now();
          studentEvent.professorId = Globals.currentCourse.professorId;
          studentEvent.date = "${now.day.toString().padLeft(2, "0")}.${now.month.toString().padLeft(2, "0")}.${now.year}";
          studentEvent.time = "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}";
          studentEvent.status = "completed";
          webService.updateStudentEvent(studentEvent);
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteAttestationScreen())).then((value) {
          Globals.currentPage = prevPage;
        });
      } else if(studentEvent.status == "completed") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteAttestationScreen())).then((value) {
          Globals.currentPage = prevPage;
        });
      } else {
        if(eventSettings.needUpload == false) {
          if(eventSettings.autoComplete == true) {
            DateTime now = DateTime.now();
            studentEvent.professorId = Globals.currentCourse.professorId;
            studentEvent.date =
            "${now.day.toString().padLeft(2, "0")}.${now.month.toString()
                .padLeft(2, "0")}.${now.year}";
            studentEvent.time =
            "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString()
                .padLeft(2, "0")}";
            studentEvent.status = "completed";
          } else {
            studentEvent.status = "waiting";
          }
            webService.updateStudentEvent(studentEvent);

          Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteAttestationScreen())).then((value) {
            Globals.currentPage = prevPage;
          });
        } else {
          studentEvent.status = "upload";
          webService.updateStudentEvent(studentEvent);
          Globals.fromOverview = false;
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              UploadFileScreen()),).then((value) {
            Globals.currentPage = prevPage;
          });
        }
      }
    } else {
      setState(() =>this.barcode = 'No matching event found for the scanned code');
      _buildErrorDialog(context, barcode);
    }

  }

  Future _buildErrorDialog(BuildContext context, String errorText) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text("QR-Code Fehler"),
          content: Text(errorText),
          actions: <Widget>[
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
      context: context,
    );
  }

  @override
  void initState() {
    _prevPage = Globals.currentPage;
    Globals.currentPage = "scanQrScreen";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(prevPage: _prevPage,),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: ResponsiveFlutter.of(context).hp(33),
            color: Color(0xff3f3d56),
          ),
          MenuButton(scaffoldKey: _scaffoldKey),
          Column(
              children: <Widget>[
                SizedBox(height: ResponsiveFlutter.of(context).verticalScale(32.0),),
                Container(
                  height: ResponsiveFlutter.of(context).verticalScale(44.5),
                  margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
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
                SizedBox(
                  height: ResponsiveFlutter.of(context).verticalScale(16.0),
                ),
                Container(
                  margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Teilnahme bestätigen',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                      color: const Color(0xff19d9d3),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: ResponsiveFlutter.of(context).verticalScale(24.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: ResponsiveFlutter.of(context).scale(6.0),),
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(48.0),
                      width: ResponsiveFlutter.of(context).scale(48.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(24.0)),
                        color: Color(0xff19d9d3),
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                            color: const Color(0xffffffff),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(1.0),
                      width: ResponsiveFlutter.of(context).scale(10.0),
                      color: Color(0xff6a65a1),
                    ),
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(1.0),
                      width: ResponsiveFlutter.of(context).scale(10.0),
                      color: Color(0xff6a65a1),
                    ),
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(1.0),
                      width: ResponsiveFlutter.of(context).scale(10.0),
                      color: Color(0xff6a65a1),
                    ),
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(1.0),
                      width: ResponsiveFlutter.of(context).scale(10.0),
                      color: Color(0xff6a65a1),
                    ),
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(48.0),
                      width: ResponsiveFlutter.of(context).scale(48.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(24.0)),
                        color: Color(0xff2b2a39),
                      ),
                      child: Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                            color: const Color(0xff6a65a1),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(1.0),
                      width: ResponsiveFlutter.of(context).scale(10.0),
                      color: Color(0xff6a65a1),
                    ),
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(1.0),
                      width: ResponsiveFlutter.of(context).scale(10.0),
                      color: Color(0xff6a65a1),
                    ),
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(1.0),
                      width: ResponsiveFlutter.of(context).scale(10.0),
                      color: Color(0xff6a65a1),
                    ),
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(1.0),
                      width: ResponsiveFlutter.of(context).scale(10.0),
                      color: Color(0xff6a65a1),
                    ),
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(48.0),
                      width: ResponsiveFlutter.of(context).scale(48.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(24.0)),
                        color: Color(0xff2b2a39),
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                            color: const Color(0xff6a65a1),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveFlutter.of(context).scale(6.0),),
                  ],
                ),
                SizedBox(height: ResponsiveFlutter.of(context).verticalScale(60.0),),
                Container(
                  height: ResponsiveFlutter.of(context).wp(86.0),
                  width: ResponsiveFlutter.of(context).wp(86.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget> [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: ResponsiveFlutter.of(context).verticalScale(32.0),),
                          Icon(Icons.camera_alt, color: Color(0xff3f3d56), size: 100.0,),
                          Text(
                            'Scannen Sie den QR-Code, \nder Ihnen in der Veranstaltung\nzur Verfügung gestellt wird.',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(2.0), //fontSize: 17
                              color: const Color(0xff3f3d56),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: ResponsiveFlutter.of(context).verticalScale(24.0),),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: SvgPicture.string(
                          _svg_fa21to,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.string(
                          _svg_e5uoll,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: SvgPicture.string(
                          _svg_mgjwe4,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: SvgPicture.string(
                          _svg_oyx8xf,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveFlutter.of(context).verticalScale(40.0),),
                Container(
                  height: ResponsiveFlutter.of(context).verticalScale(48.0),
                  width: ResponsiveFlutter.of(context).wp(86.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                    padding: EdgeInsets.all(0.0),
                    ),
                    onPressed: _scan,
                    child: Text(
                      'Kamera aktivieren',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.0), //fontSize: 17
                        color: const Color(0xffffffff),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(6.0)),
                    color: Color(0xff00b1ac),
                    border: Border.all(
                        width: ResponsiveFlutter.of(context).scale(2.0), color: Color(0xff00b1ac)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

const String _svg_e5uoll =
    '<svg viewBox="24.5 233.5 21.5 21.0" ><path transform="translate(24.5, 233.5)" d="M 0 0 L 0 21" fill="none" stroke="#3f3d56" stroke-width="3" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.0, 1.0, -1.0, 0.0, 46.0, 235.0)" d="M 0 0 L 0 21" fill="none" stroke="#3f3d56" stroke-width="3" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_fa21to =
    '<svg viewBox="0.0 0.0 21.0 21.5" ><path transform="matrix(0.0, 1.0, -1.0, 0.0, 21.0, 0.0)" d="M 0 0 L 0 21" fill="none" stroke="#3f3d56" stroke-width="3" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(-1.0, 0.0, 0.0, -1.0, 19.5, 21.5)" d="M 0 0 L 0 21" fill="none" stroke="#3f3d56" stroke-width="3" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_mgjwe4 =
    '<svg viewBox="0.0 0.0 21.5 21.0" ><path transform="matrix(-1.0, 0.0, 0.0, -1.0, 21.5, 21.0)" d="M 0 0 L 0 21" fill="none" stroke="#3f3d56" stroke-width="3" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.0, -1.0, 1.0, 0.0, 0.0, 19.5)" d="M 0 0 L 0 21" fill="none" stroke="#3f3d56" stroke-width="3" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_oyx8xf =
    '<svg viewBox="0.0 0.0 21.0 21.5" ><path transform="matrix(0.0, -1.0, 1.0, 0.0, 0.0, 21.5)" d="M 0 0 L 0 21" fill="none" stroke="#3f3d56" stroke-width="3" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(1.5, 0.0)" d="M 0 0 L 0 21" fill="none" stroke="#3f3d56" stroke-width="3" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
