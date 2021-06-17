
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/blocs/bloc_provider.dart';
import 'package:studybuddy/blocs/data_bloc.dart';
import 'package:studybuddy/objects/file_upload_object.dart';
import 'package:studybuddy/objects/student_event_object.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/widgets/custom_back_button.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';

import 'main_student_screen.dart';

class CompleteAttestationScreen extends StatefulWidget {
  CompleteAttestationScreen({Key key,}) : super(key: key);

  @override
  _CompleteAttestationScreenState createState() =>
      _CompleteAttestationScreenState();
}

class _CompleteAttestationScreenState extends State<CompleteAttestationScreen> {
  List<FileUploadObject> _fileList = [];
  bool _isCompleted = false;
  Map<List<FileUploadObject>, StudentEventObject> fileUploadMap;
  DatabaseService dbService = DatabaseService.instance;
  StudentEventObject _studentEvent;
  String _prevPage;
  DataBloc _dataBloc;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  String _fileSize(FileUploadObject fileUploadObject) {
    int sizeInByte = fileUploadObject.size;

    if (sizeInByte > 500000) {
      return ((sizeInByte / 1000) / 1000).toStringAsFixed(2) + "MB";
    }
    if (sizeInByte > 500) {
      return (sizeInByte / 1000).toStringAsFixed(2) + "KB";
    }
    return sizeInByte.toStringAsFixed(2) + "B";
  }

  Widget _fileListWidget() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _fileList.length,
        itemBuilder: (context, index) {
          FileUploadObject currentFile = _fileList[index];
          return Container(
            margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0), bottom: ResponsiveFlutter.of(context).verticalScale(8.0), right: ResponsiveFlutter.of(context).scale(24.0)),
            width: ResponsiveFlutter.of(context).wp(86.0),
            height: ResponsiveFlutter.of(context).verticalScale(52.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: ResponsiveFlutter.of(context).verticalScale(40.0),
                  width: ResponsiveFlutter.of(context).scale(40.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(10.0)),
                    border: Border.all(
                      width: ResponsiveFlutter.of(context).scale(2.0),
                      color: Color(0xff3f3d56),
                    ),
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
                  //width: 220.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        currentFile.fileName.split(".").first,
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
                        getUploadTimeFromFile(currentFile),
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          color: const Color(0xff3f3d56),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        _fileSize(currentFile) +
                            " ." +
                            currentFile.fileName.split(".").last,
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
                SizedBox(
                  width: ResponsiveFlutter.of(context).scale(8.0),
                ),
              ],
            ),
          );
        });
  }

  String getUploadTimeFromFile(FileUploadObject file) {
    DateTime date = DateTime.parse(file.uploadTime);
    return '${date.day.toString().padLeft(2, "0")}.${date.month.toString().padLeft(2, "0")}.${date.year} ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")} Uhr';
  }

  @override
  void initState() {
    _prevPage = Globals.currentPage;
    Globals.currentPage = "completeAttestationScreen";
    _dataBloc = BlocProvider.of<DataBloc>(context);
    _dataBloc.getUploadFileData(Globals.currentUser.id, Globals.currentEvent.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(prevPage: _prevPage,),
      backgroundColor: Colors.white,
      body: StreamBuilder(
      stream: _dataBloc.uploadFileData,
        builder: (BuildContext context,
            AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data[0] != fileUploadMap) {
                fileUploadMap = snapshot.data[0];
                _fileList = fileUploadMap.keys.elementAt(0);
                _studentEvent = fileUploadMap.values.elementAt(0);
                _isCompleted = "completed" == _studentEvent.status;
              }
              return Stack(
                children: <Widget>[
                  Container(
                    height: ResponsiveFlutter.of(context).hp(40.0),
                    color: Color(0xff3f3d56),
                  ),
                  MenuButton(scaffoldKey: _scaffoldKey),
                  Column(
                    children: <Widget>[
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
                        margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                        alignment: Alignment.topLeft,
                        child: Text(
                          _isCompleted
                              ? 'Praktikum bestanden'
                              : 'Fast abgeschlossen',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                            color: const Color(0xff19d9d3),
                            letterSpacing: -0.4,
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
                          SizedBox(
                            width: ResponsiveFlutter.of(context).scale(6.0),
                          ),
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
                              color: Color(0xff19d9d3),
                            ),
                            child: Center(
                              child: Text(
                                '2',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                                  color: Colors.white,
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
                              color: _isCompleted
                                  ? Color(0xff19d9d3)
                                  : Color(0xff2b2a39),
                            ),
                            child: Center(
                              child: Text(
                                '3',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                                  color: _isCompleted
                                      ? Colors.white
                                      : Color(0xff6a65a1),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveFlutter.of(context).scale(6.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ResponsiveFlutter.of(context).verticalScale(24.0),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0), right: ResponsiveFlutter.of(context).scale(24.0)),
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
                        margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0), right: ResponsiveFlutter.of(context).scale(24.0)),
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
                      SizedBox(
                        height: ResponsiveFlutter.of(context).verticalScale(32.0),
                      ),
                      _isCompleted
                          ? Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Color(0xff00b1ac),
                                    size: 48.0,
                                  ),
                                  SizedBox(
                                    width: ResponsiveFlutter.of(context).scale(16.0),
                                  ),
                                  Text(
                                    'Sie haben das Praktikum bestanden.',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.chat,
                                    color: Color(0xff00b1ac),
                                    size: 48.0,
                                  ),
                                  SizedBox(
                                    width: ResponsiveFlutter.of(context).scale(16.0),
                                  ),
                                  Text(
                                    'Abgaben werden überprüft.',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: ResponsiveFlutter.of(context).verticalScale(22.0),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                              color: const Color(0xff3f3d56),
                            ),
                            children: [
                              TextSpan(
                                text: 'Sie haben ',
                              ),
                              TextSpan(
                                text: _fileList.length.toString(),
                                style: TextStyle(
                                  color: const Color(0xff00b1ac),
                                ),
                              ),
                              TextSpan(
                                text: _fileList.length == 1 ? ' Datei erfolgreich hochgeladen.' : ' Dateien erfolgreich hochgeladen.',
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(8.0)),
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(180.0),
                        child: _fileListWidget(),
                      ),
                      SizedBox(
                        height: ResponsiveFlutter.of(context).verticalScale(16.0),
                      ),
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(48.0),
                        width: ResponsiveFlutter.of(context).wp(86.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                          padding: EdgeInsets.all(0.0),
          ),
                          onPressed: () {
                            if(_prevPage != "mainStudentScreen") {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainStudentScreen())).then((value) {
                                Globals.currentPage = _prevPage;
                              });
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            'Fertig',
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
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }
}