import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/objects/file_upload_object.dart';
import 'package:studybuddy/objects/student_event_object.dart';
import 'package:studybuddy/screens/main_student_screen.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/services/web_service.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';
import 'complete_attestation_screen.dart';

class UploadFileScreen extends StatefulWidget {
  UploadFileScreen({
    Key key,
  }) : super(key: key);

  _UploadFileScreenState createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  List<File> _files = [];
  Future<List<FileUploadObject>> _future;
  DatabaseService dbService = DatabaseService.instance;
  WebService webService = WebService.instance;
  bool once = true;
  bool _isUpload;
  String _prevPage;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  void _selectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      _files.add(File(result.files.single.path));
      setState(() {
      });
    }
  }

  String _fileSize(File file) {
    int sizeInByte = file.statSync().size;

    if (sizeInByte > 500000) {
      return ((sizeInByte / 1000) / 1000).toStringAsFixed(2) + "MB";
    }
    if (sizeInByte > 500) {
      return (sizeInByte / 1000).toStringAsFixed(2) + "KB";
    }
    return sizeInByte.toStringAsFixed(2) + "B";
  }

  _editFile(File file) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result.count != 0) {
      _files.remove(file);
      _files.add(File(result.files.single.path));
      setState(() {});
    }
  }

  _removeFile(File file) async {
    _files.remove(file);
    setState(() {});
  }

  Widget _fileListWidget() {
    return Container(
      height: ResponsiveFlutter.of(context).verticalScale(144.0),
        child: _files.isNotEmpty ? ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _files.length,
        itemBuilder: (context, index) {
          File currentFile = _files[index];
          String fileName = currentFile.path.split("/").last.split(".").first;
          String fileType = currentFile.path.split("/").last.split(".").last;
          String fileSize = _fileSize(currentFile);
          return Container(
            margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0), bottom: ResponsiveFlutter.of(context).verticalScale(8.0), right: ResponsiveFlutter.of(context).scale(24.0)),
            width: ResponsiveFlutter.of(context).wp(86),
            height: ResponsiveFlutter.of(context).verticalScale(40.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: ResponsiveFlutter.of(context).verticalScale(40.0),
                  width: ResponsiveFlutter.of(context).scale(40.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(10.0)),
                    border: Border.all(width: ResponsiveFlutter.of(context).scale(2.0), color: Color(0xff3f3d56),),
                  ),
                  child: Icon(
                    Icons.insert_drive_file,
                    color: Color(0xff3f3d56),
                  ),
                ),
                SizedBox(
                  width: ResponsiveFlutter.of(context).scale(4.0),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        fileName,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                          color: const Color(0xff00b1ac),
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "$fileSize .$fileType",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                          color: const Color(0xff3f3d56),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveFlutter.of(context).scale(4.0)),
                Container(
                  height: ResponsiveFlutter.of(context).verticalScale(40.0),
                  width: ResponsiveFlutter.of(context).scale(40.0),
                  decoration: BoxDecoration(
                    color: Color(0xffdce4e9),
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(20.0))
                  ),
                  child:IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () => _editFile(currentFile),
                ),
                ),
            SizedBox(width: ResponsiveFlutter.of(context).scale(8.0)),
            Container(
              height: ResponsiveFlutter.of(context).verticalScale(40.0),
              width: ResponsiveFlutter.of(context).scale(40.0),
              decoration: BoxDecoration(
                  color: Color(0xffdce4e9),
                  borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(20.0))
              ),
              child:IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => _removeFile(currentFile),
                ),
            ),
              ],
            ),
          );
        }
        ) : Center(
          child: Text(
            "Sie haben noch keine Dateien hochgeladen!",
            style: TextStyle(
              fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
              fontFamily: "Nunito",
              color: Color(0xff3f3d56),
            ),
            textAlign: TextAlign.left,
          ),
        ),
    );
  }

  getData() {
    _future = dbService.getAllFileUploadsOfStudentAndEvent(
        Globals.currentUser.id, Globals.currentEvent.id);
  }

  @override
  void initState() {
    getData();
    _isUpload = Globals.fromOverview;
    _prevPage = Globals.currentPage;
    Globals.fromOverview = false;
    Globals.currentPage = "uploadFileScreen";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(prevPage: _prevPage),
      backgroundColor: Colors.white,
      body:FutureBuilder(
          future: _future,
          builder: (BuildContext context,
              AsyncSnapshot<List<FileUploadObject>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  Container(
                    height: ResponsiveFlutter.of(context).hp(40),
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
                            _isUpload ? 'Dateiupload' : 'Teilnahme bestätigt',
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
                              color: Color(0xff19d9d3),
                            ),
                            Container(
                              height: ResponsiveFlutter.of(context).verticalScale(1.0),
                              width: ResponsiveFlutter.of(context).scale(10.0),
                              color: Color(0xff19d9d3),
                            ),
                            Container(
                              height: ResponsiveFlutter.of(context).verticalScale(1.0),
                              width: ResponsiveFlutter.of(context).scale(10.0),
                              color: Color(0xff19d9d3),
                            ),
                            Container(
                              height: ResponsiveFlutter.of(context).verticalScale(1.0),
                              width: ResponsiveFlutter.of(context).scale(10.0),
                              color: Color(0xff19d9d3),
                            ),
                            Container(
                              height: ResponsiveFlutter.of(context).verticalScale(48.0),
                              width: ResponsiveFlutter.of(context).scale(48.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(24.0)),
                                color: _isUpload ? Color(0xff19d9d3) : Color(0xff2b2a39),
                              ),
                              child: Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                                    color: _isUpload ? Colors.white : Color(0xff6a65a1),
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
                        SizedBox(
                          height: ResponsiveFlutter.of(context).verticalScale(24.0),
                        ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                        left: ResponsiveFlutter.of(context).scale(24.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                                    child: Text(
                                      Globals.currentCourse.name,
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                        color: const Color(0xff19d9d3),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                        left: ResponsiveFlutter.of(context).scale(24.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                                    child: Text(
                                      '${Globals.getDayOfEvent(Globals.currentEvent)}, ${Globals.currentEvent.date} | ${Globals.currentEvent.time}',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                        color: const Color(0xfffefeff),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(32.0),),
                        _isUpload ? Container(
                          height: ResponsiveFlutter.of(context).verticalScale(48.0),
                          width: ResponsiveFlutter.of(context).wp(86.0),
                          margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).verticalScale(16.0)),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(8.0), 0.0, ResponsiveFlutter.of(context).scale(8.0), 0.0),
                            ),
                            onPressed: _selectFile,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.search,
                                  color: Color(0xff3f3d56),
                                ),
                                SizedBox(
                                  width: ResponsiveFlutter.of(context).scale(4.0),
                                ),
                                Text(
                                  'Durchsuchen... ',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                    color: const Color(0xff3f3d56),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(6.0)),
                            border: Border.all(width: ResponsiveFlutter.of(context).scale(2.0), color: Color(0xff3f3d56)),
                          ),
                        ) : Container(
                          height: ResponsiveFlutter.of(context).verticalScale(208.0),
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: ResponsiveFlutter.of(context).verticalScale(8.0),),
                              Stack(
                                alignment: Alignment.center,
                                children: <Widget> [
                                  Icon(Icons.calendar_today, color: Color(0xff00b1ac), size: 120.0,),
                                  Container(
                                    margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).verticalScale(24.0)),
                                    child: Icon(Icons.check, color: Color(0xff00b1ac), size: 96.0,),
                                  ),
                                ]
                              ),
                              SizedBox(height: ResponsiveFlutter.of(context).verticalScale(32.0),),
                              Text(
                                'Ihre Teilnahme wurde bestätigt.',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: ResponsiveFlutter.of(context).fontSize(2.2), //fontSize: 18
                                  color: const Color(0xff3f3d56),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        _isUpload ? _fileListWidget() : Container(),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(16.0)),
                        Container(
                          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                          child: Text(
                            'Das Hochladen der Praktikumsaufgaben kann auch zu einem späteren Zeitpunkt über die App, oder das StuddyBuddy Webportal erfolgen.',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                              color: const Color(0xff3f3d56),
                              letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(16.0)),
                        Container(
                          width: ResponsiveFlutter.of(context).wp(86),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: ResponsiveFlutter.of(context).verticalScale(48.0),
                              width: ResponsiveFlutter.of(context).scale(132.0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(0.0),
                                ),
                                onPressed: () {
                                  //TODO: Show dialog if files were selected that will be lost
                                  if(_prevPage != "mainStudentScreen") {
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainStudentScreen())).then((value) {
                                      Globals.currentPage = _prevPage;
                                    });
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text(
                                  'Später abgeben',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: ResponsiveFlutter.of(context).fontSize(2.0), //fontSize: 17
                                    color: const Color(0xff6a65a1),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(6.0)),
                                border: Border.all(
                                    width: ResponsiveFlutter.of(context).scale(2.0), color: Color(0xff6a65a1)),
                              ),
                            ),
                            Container(
                              height: ResponsiveFlutter.of(context).verticalScale(48.0),
                              width: ResponsiveFlutter.of(context).scale(132),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(0.0),
                                ),
                                onPressed: () async {
                                  if(_isUpload) {
                                    if(_files.length == 1) {
                                      webService.uploadFile(_files.first
                                          , Globals.currentEvent.id,
                                          Globals.currentUser.id);
                                    } else if(_files.isNotEmpty) {
                                      webService.uploadFiles(_files, Globals.currentEvent.id, Globals.currentUser.id);
                                    }
                                    StudentEventObject studentEvent = StudentEventObject(Globals.currentUser.id, Globals.currentEvent.id, null, null, null, "waiting");
                                    webService.updateStudentEvent(studentEvent);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CompleteAttestationScreen()),
                                    ).then((value) {
                                      Globals.currentPage = _prevPage;
                                    });
                                  } else {
                                    _isUpload = true;
                                    setState(() {

                                    });
                                  }
                                },
                                child: Text(
                                  _isUpload ? 'Dateien hochladen' : 'Jetzt abgeben',
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
                              ),
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }
}