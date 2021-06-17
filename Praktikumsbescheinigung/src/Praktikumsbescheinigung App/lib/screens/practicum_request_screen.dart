import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/blocs/bloc_provider.dart';
import 'package:studybuddy/blocs/data_bloc.dart';
import 'package:studybuddy/objects/course_object.dart';
import 'package:studybuddy/objects/event_object.dart';
import 'package:studybuddy/objects/file_upload_object.dart';
import 'package:studybuddy/objects/professor_object.dart';
import 'package:studybuddy/objects/student_event_object.dart';
import 'package:studybuddy/objects/student_object.dart';
import 'package:studybuddy/services/blockchain_service.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/services/web_service.dart';
import 'package:studybuddy/widgets/custom_back_button.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class PracticumRequestScreen extends StatefulWidget {
  PracticumRequestScreen({
    Key key,
    this.student,
    this.event,
    this.status,
    this.course,
  }) : super(key: key);

  final StudentObject student;
  final EventObject event;
  final String status;
  final CourseObject course;

  _PracticumRequestScreenState createState() => _PracticumRequestScreenState();
}

class _PracticumRequestScreenState extends State<PracticumRequestScreen> {
  DatabaseService dbService = DatabaseService.instance;
  WebService webService = WebService.instance;
  BlockchainService blockchain = BlockchainService.instance;
  DataBloc _dataBloc;
  String _prevPage;
  List<FileUploadObject> _fileList;
  StudentObject student;
  EventObject event;

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

  void _showAlertDialog(int eventId, int studentId, String fileName) async {
    final String dir = (await getExternalStorageDirectory()).path;
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Praktikumsdatei herunterladen"),
          content: Text("Wollen Sie die Praktikumsdatei $fileName herunterladen? \n\nDiese wird unter $dir/Downloads/${event.name}/${student.fhIdentifier}/$fileName gespeichert."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Abbrechen")),
            TextButton(
                onPressed: () async {
                 await webService.downloadFile(eventId, event.name, studentId, student.fhIdentifier, fileName);
                  Navigator.of(context).pop();
                },
                child: Text("Herunterladen")),
          ],
        );
      },
    );
  }

  Widget _fileListWidget() {
    return Expanded(
      child: _fileList.isNotEmpty ? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _fileList.length,
          itemBuilder: (context, index) {
            FileUploadObject currentFile = _fileList[index];
            return InkWell(
              onTap: () {
                _showAlertDialog(currentFile.eventId, currentFile.studentId, currentFile.fileName);
              },
                child: Container(
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
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).scale(8.0)),
                    child: Icon(Icons.arrow_forward_ios, color: Color(0xff3f3d56)),
                  ),
                ],
              ),
                ),
            );
          }
      ) : Center(
        child: Text(
          "Es wurden keine Dateien hochgeladen!",
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

  Future<File> generatePdf(CourseObject course, StudentEventObject studentEvent) async {
    final pdf = pw.Document();
    ProfessorObject professor = Globals.currentUser;
    final painter = QrPainter(
      emptyColor: Colors.white,
      errorCorrectionLevel: QrErrorCorrectLevel.Q,
      data: course.id.toString(),
      version: QrVersions.auto,
    );
    ByteData imageData = await painter.toImageData(100.0);
    final imageBytes = imageData.buffer.asUint8List();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text("Testatbescheinigung",
                      style: pw.TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: pw.TextAlign.left
                  ),
                  pw.SizedBox(height: 16.0),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: <pw.Widget>[
                        pw.Container(
                          width: 280.0,
                          child: pw.Text(
                              "Bescheinigung für das Bestehen des Kurses ${course.name}",
                              style: pw.TextStyle(
                                fontSize: 18.0,
                              )
                          ),
                        ),
                        pw.Image(pw.MemoryImage(imageBytes)),
                      ]
                  ),
                  pw.SizedBox(height: 16.0),
                  pw.Text("Student: ${widget.student.firstName} ${widget.student.lastName}",
                      style: pw.TextStyle(
                          fontSize: 15.0,
                          fontWeight: pw.FontWeight.bold
                      )
                  ),
                  pw.SizedBox(height: 16.0),
                  pw.Text(
                      "Testat erhalten am ${studentEvent.date} um ${studentEvent.time} Uhr",
                      style: pw.TextStyle(
                        fontSize: 15.0,
                      )
                  ),
                  pw.Text("von ${professor.title} ${professor.firstName} ${professor.lastName}",
                      style: pw.TextStyle(
                        fontSize: 15.0,
                      )
                  ),
                ]
            ),
          );
        })); // Page


    pdf.document.info = PdfInfo(pdf.document);
    pdf.document.info.params['/SecurityKey'] =
        PdfSecString.fromString(pdf.document.info, Globals.createCryptoRandomString(64));


    final String dir = (await getExternalStorageDirectory()).path;
    await Directory('$dir/Testate').create(recursive: true);
    final String fileName =  widget.course.name.replaceAll(RegExp(r"\s+"), "_").replaceAll(r".", "_");
    final String path = '$dir/Testate/$fileName.pdf';
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  @override
  void initState() {
    student = widget.student;
    event = widget.event;
    _prevPage = Globals.currentPage;
    Globals.currentPage = "practicumRequestScreen";
    _dataBloc = BlocProvider.of<DataBloc>(context);
    _dataBloc.getRequestData(student.id, event.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(prevPage: _prevPage),
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: _dataBloc.requestData,
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if(snapshot.data[0] != _fileList) {
                _fileList = snapshot.data[0];
              }
              return Stack(children: <Widget>[
                    Container(
                      height: ResponsiveFlutter.of(context).hp(50),
                      color: Color(0xff3f3d56),
                    ),
                    MenuButton(scaffoldKey: _scaffoldKey),
                    Column(children: <Widget>[
                      SizedBox(
                          height:
                          ResponsiveFlutter.of(context).verticalScale(32.0)),
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
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(24.0),),
                      Container(
                        alignment: Alignment.topCenter,
                        child: SvgPicture.string(
                          _svg_5saa4b,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveFlutter.of(context).verticalScale(24.0),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                              color: const Color(0xff19d9d3),
                            ),
                          children: [
                            TextSpan(
                              text: '${student.lastName}, ${student.firstName} ',
                            ),
                            TextSpan(
                              text:'(${student.fhIdentifier})',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                      ),
                      SizedBox(
                        height: ResponsiveFlutter.of(context).verticalScale(24.0),
                      ),
                      widget.status != null ? Container(
                        height: ResponsiveFlutter.of(context).verticalScale(62.0),
                        alignment: Alignment.center,
                        child: Text(
                          widget.status == "completed" ? 'Praktikum bestanden' : 'Praktikum nicht bestanden',
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                            color: widget.status == "completed" ? Colors.green : Colors.redAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ) : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: ResponsiveFlutter.of(context).verticalScale(40.0),
                                width: ResponsiveFlutter.of(context).scale(40.0),
                                decoration: BoxDecoration(
                                    color: Color(0xff00b1ac),
                                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(20.0))
                                ),
                                child:IconButton(
                                  icon: Icon(Icons.check, color: Colors.white),
                                  onPressed: () async {
                                    DateTime now = DateTime.now();
                                    StudentEventObject _studentEvent = StudentEventObject(widget.student.id, widget.event.id, Globals.currentUser.id, "${now.day.toString().padLeft(2, "0")}.${now.month.toString().padLeft(2, "0")}.${now.year}", "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}", "completed");

                                    bool isLastEvent = await webService.updateStudentEvent(_studentEvent);
                                    print("is last event: $isLastEvent");
                                    if(isLastEvent) {
                                      File pdf = await generatePdf(widget.course, _studentEvent);
                                      await blockchain.signFile(pdf);
                                      await webService.uploadCertificate(pdf, widget.course.id, widget.student.id);
                                    }
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              SizedBox(height: ResponsiveFlutter.of(context).verticalScale(4.0),),
                              Text("Testat vergeben",
                                style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context).fontSize(1.6), //fontSize: 14
                                  fontFamily: "Nunito",
                                  color: Color(0xff00b1ac),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: ResponsiveFlutter.of(context).scale(24.0),),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: ResponsiveFlutter.of(context).verticalScale(40.0),
                                width: ResponsiveFlutter.of(context).scale(40.0),
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(20.0))
                                ),
                                child:IconButton(
                                  icon: Icon(Icons.close, color: Colors.white),
                                  onPressed: () {
                                    DateTime now = DateTime.now();
                                    StudentEventObject _studentEvent = StudentEventObject(widget.student.id, widget.event.id, Globals.currentUser.id, "${now.day.toString().padLeft(2, "0")}.${now.month.toString().padLeft(2, "0")}.${now.year}", "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}", "failed");
                                    webService.updateStudentEvent(_studentEvent);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              SizedBox(height: ResponsiveFlutter.of(context).verticalScale(4.0),),
                              Text("Testat verweigern",
                                style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context).fontSize(1.6), //fontSize: 14
                                  fontFamily: "Nunito",
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ResponsiveFlutter.of(context).verticalScale(56.0),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: ResponsiveFlutter.of(context).scale(24.0)),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Dateiupload',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                            color: const Color(0xff19d9d3),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(8.0)),
                      _fileListWidget(),
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

const String _svg_5saa4b =
    '<svg viewBox="0.0 0.0 84.0 77.0" ><path transform="translate(2398.0, 7214.0)" d="M -2356.00048828125 -7137.00048828125 L -2356.0009765625 -7137.00146484375 L -2367.59375 -7148.8330078125 C -2374.31982421875 -7148.53564453125 -2380.09765625 -7144.1748046875 -2382.3134765625 -7137.72216796875 C -2384.70263671875 -7139.6845703125 -2386.884765625 -7141.91748046875 -2388.80029296875 -7144.35791015625 C -2390.728759765625 -7146.81640625 -2392.39208984375 -7149.4912109375 -2393.744140625 -7152.30908203125 C -2395.12109375 -7155.18017578125 -2396.18115234375 -7158.2119140625 -2396.89404296875 -7161.31982421875 C -2397.6279296875 -7164.5166015625 -2398 -7167.818359375 -2398 -7171.13330078125 C -2398 -7176.92041015625 -2396.8896484375 -7182.5341796875 -2394.69921875 -7187.8193359375 C -2392.583984375 -7192.92333984375 -2389.5556640625 -7197.5078125 -2385.698486328125 -7201.44482421875 C -2381.84130859375 -7205.3818359375 -2377.349609375 -7208.47265625 -2372.3486328125 -7210.63134765625 C -2367.17041015625 -7212.86669921875 -2361.67041015625 -7214 -2356.00048828125 -7214 C -2350.33056640625 -7214 -2344.830078125 -7212.86669921875 -2339.65185546875 -7210.63134765625 C -2334.650390625 -7208.47265625 -2330.15869140625 -7205.3818359375 -2326.30126953125 -7201.44482421875 C -2322.44384765625 -7197.5078125 -2319.41552734375 -7192.923828125 -2317.30029296875 -7187.8193359375 C -2315.1103515625 -7182.5341796875 -2313.999755859375 -7176.92041015625 -2313.999755859375 -7171.13330078125 C -2313.999755859375 -7167.81884765625 -2314.37158203125 -7164.517578125 -2315.10546875 -7161.31982421875 C -2315.81884765625 -7158.2119140625 -2316.87890625 -7155.18017578125 -2318.256103515625 -7152.30859375 C -2319.60888671875 -7149.48974609375 -2321.272216796875 -7146.814453125 -2323.2001953125 -7144.35791015625 C -2325.11669921875 -7141.91552734375 -2327.299072265625 -7139.6826171875 -2329.68701171875 -7137.7216796875 C -2331.902099609375 -7144.17431640625 -2337.67919921875 -7148.53564453125 -2344.40576171875 -7148.8330078125 L -2356 -7137.00146484375 L -2356.00048828125 -7137.00048828125 Z M -2377.874755859375 -7177.794921875 L -2377.873779296875 -7177.79443359375 L -2369.85400390625 -7175.8232421875 C -2370.982421875 -7173.517578125 -2371.554931640625 -7171.138671875 -2371.554931640625 -7168.751953125 C -2371.554931640625 -7159.99853515625 -2364.5771484375 -7152.876953125 -2356.00048828125 -7152.876953125 C -2347.423095703125 -7152.876953125 -2340.44482421875 -7159.99853515625 -2340.44482421875 -7168.751953125 C -2340.44482421875 -7171.166015625 -2341.01708984375 -7173.544921875 -2342.145751953125 -7175.8232421875 L -2330.442626953125 -7178.7001953125 C -2329.4345703125 -7178.94921875 -2328.783447265625 -7179.7158203125 -2328.783447265625 -7180.654296875 C -2328.783447265625 -7181.59228515625 -2329.4345703125 -7182.359375 -2330.442626953125 -7182.60791015625 L -2353.58154296875 -7188.31201171875 C -2354.36767578125 -7188.50390625 -2355.17919921875 -7188.60107421875 -2355.99365234375 -7188.60107421875 C -2356.8076171875 -7188.60107421875 -2357.619140625 -7188.50390625 -2358.40576171875 -7188.31201171875 L -2381.569580078125 -7182.619140625 C -2382.57177734375 -7182.37060546875 -2383.21923828125 -7181.6015625 -2383.21923828125 -7180.65966796875 C -2383.21923828125 -7179.71826171875 -2382.57177734375 -7178.94921875 -2381.569580078125 -7178.7001953125 L -2380.791015625 -7178.51513671875 L -2380.791015625 -7171.27001953125 C -2381.70458984375 -7170.7119140625 -2382.249755859375 -7169.7705078125 -2382.249755859375 -7168.751953125 C -2382.249755859375 -7167.7783203125 -2381.75830078125 -7166.8876953125 -2380.90087890625 -7166.30908203125 L -2382.796142578125 -7158.5830078125 C -2382.9150390625 -7158.09130859375 -2382.819091796875 -7157.5654296875 -2382.5458984375 -7157.208984375 C -2382.36572265625 -7156.974609375 -2382.126953125 -7156.84521484375 -2381.873779296875 -7156.84521484375 L -2376.793212890625 -7156.84521484375 C -2376.539306640625 -7156.84521484375 -2376.300048828125 -7156.974609375 -2376.11962890625 -7157.20947265625 C -2375.8466796875 -7157.56591796875 -2375.750732421875 -7158.091796875 -2375.86962890625 -7158.5830078125 L -2377.766357421875 -7166.30859375 C -2376.90869140625 -7166.8876953125 -2376.417236328125 -7167.77783203125 -2376.417236328125 -7168.751953125 C -2376.417236328125 -7169.7705078125 -2376.962158203125 -7170.7119140625 -2377.874755859375 -7171.27001953125 L -2377.874755859375 -7177.79345703125 L -2377.874755859375 -7177.794921875 Z" fill="#2b2a39" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
