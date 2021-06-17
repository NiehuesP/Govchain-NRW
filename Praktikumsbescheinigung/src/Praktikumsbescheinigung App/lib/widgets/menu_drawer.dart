import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:studybuddy/objects/student_object.dart';
import 'package:studybuddy/screens/attestation_screen.dart';
import 'package:studybuddy/screens/exams_screen.dart';
import 'package:studybuddy/screens/login_screen.dart';
import 'package:studybuddy/screens/main_professor_screen.dart';
import 'package:studybuddy/screens/main_student_screen.dart';
import 'package:studybuddy/screens/modules_screen.dart';
import 'package:studybuddy/screens/practicum_screen.dart';
import 'package:studybuddy/screens/scan_qr_screen.dart';
import 'package:studybuddy/screens/settings_screen.dart';
import 'package:studybuddy/screens/testament_screen.dart';
import 'package:studybuddy/services/auth_service.dart';
import 'package:studybuddy/services/globals.dart';

class MenuDrawer extends StatefulWidget {
  MenuDrawer({
    Key key, this.prevPage
  }) : super(key: key);

  final String prevPage;

  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  AuthService authService = AuthService();

  _logout() {
    authService.logout();
    if(Navigator.of(context, rootNavigator: true).canPop()) {
      while(Navigator.of(context, rootNavigator:  true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    } else {
      Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()),);
    }
  }

  studentDrawer() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: Drawer(
        child: Container(
          color: Color(0xff3f3d56),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Container(
                  height: 32.0,
                ),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today, color: Globals.currentPage == "mainStudentScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Übersicht",
                  style: TextStyle(
                    color: Globals.currentPage == "mainStudentScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if(Globals.currentPage == "uploadFileScreen" || Globals.currentPage == "completeAttestationScreen") {
                    Navigator.of(context).pop();
                    Globals.currentPage = widget.prevPage;
                  }
                  if(Globals.currentPage != "mainStudentScreen") {
                    String prevPage = Globals.currentPage;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainStudentScreen())).then((value) {
                      Globals.currentPage = prevPage;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.local_library, color: Globals.currentPage == "scanQrScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Praktikum",
                  style: TextStyle(
                    color: Globals.currentPage == "scanQrScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if(Globals.currentPage == "uploadFileScreen" || Globals.currentPage == "completeAttestationScreen") {
                    Navigator.of(context).pop();
                    Globals.currentPage = widget.prevPage;
                  }
                  if(Globals.currentPage != "scanQrScreen") {
                    String prevPage = Globals.currentPage;
                    Navigator.of(context)
                        .push(
                        MaterialPageRoute(builder: (context) => ScanQrScreen()))
                        .then((value) {
                      Globals.currentPage = prevPage;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.star, color: Globals.currentPage == "attestationScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Testate",
                  style: TextStyle(
                    color: Globals.currentPage == "attestationScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if(Globals.currentPage == "attestationDetailScreen") {
                    Navigator.of(context).pop();
                    Globals.currentPage = widget.prevPage;
                  }
                  if(Globals.currentPage != "attestationScreen") {
                    String prevPage = Globals.currentPage;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AttestationScreen())).then((value) {
                      Globals.currentPage = prevPage;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file, color: Globals.currentPage == "testamentScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Belege",
                  style: TextStyle(
                    color: Globals.currentPage == "testamentScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if(Globals.currentPage != "testamentScreen") {
                    String prevPage = Globals.currentPage;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestamentScreen())).then((value) {
                      Globals.currentPage = prevPage;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Globals.currentPage == "settingsScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Einstellungen",
                  style: TextStyle(
                    color: Globals.currentPage == "settingsScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if(Globals.currentPage != "settingsScreen") {
                    String prevPage = Globals.currentPage;
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => SettingsScreen())).then((value) {
                      Globals.currentPage = prevPage;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text("Abmelden",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _logout();
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline, color: Globals.currentPage == "helpScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Hilfe",
                  style: TextStyle(
                    color: Globals.currentPage == "helpScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline, color: Globals.currentPage == "impressumScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Impressum",
                  style: TextStyle(
                    color: Globals.currentPage == "impressumScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  professorDrawer() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: Drawer(
        child: Container(
          color: Color(0xff3f3d56),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Container(
                  height: 32.0,
                ),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today, color: Globals.currentPage == "mainProfessorScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Übersicht",
                  style: TextStyle(
                    color: Globals.currentPage == "mainProfessorScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if(Globals.currentPage == "generateQrScreen" || Globals.currentPage == "practicumEventScreen") {
                    Navigator.of(context).pop();
                    Globals.currentPage = widget.prevPage;
                  }
                  if(Globals.currentPage != "mainProfessorScreen") {
                    String prevPage = Globals.currentPage;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainProfessorScreen())).then((value) {
                      Globals.currentPage = prevPage;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.local_library, color: Globals.currentPage == "practicumScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Praktikum",
                  style: TextStyle(
                    color: Globals.currentPage == "practicumScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if(Globals.currentPage == "generateQrScreen" || Globals.currentPage == "practicumEventScreen") {
                    Navigator.of(context).pop();
                    Globals.currentPage = widget.prevPage;
                  }
                  if(Globals.currentPage != "practicumScreen") {
                    String prevPage = Globals.currentPage;
                    Navigator.of(context)
                        .push(
                        MaterialPageRoute(builder: (context) => PracticumScreen()))
                        .then((value) {
                      Globals.currentPage = prevPage;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(MdiIcons.teach, color: Globals.currentPage == "modulesScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Module",
                  style: TextStyle(
                    color: Globals.currentPage == "modulesScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if(Globals.currentPage != "modulesScreen") {
                    String prevPage = Globals.currentPage;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModulesScreen())).then((value) {
                      Globals.currentPage = prevPage;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.access_time, color: Globals.currentPage == "examsScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Klausuren",
                  style: TextStyle(
                    color: Globals.currentPage == "examsScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if(Globals.currentPage != "examsScreen") {
                    String prevPage = Globals.currentPage;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExamsScreen())).then((value) {
                      Globals.currentPage = prevPage;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Globals.currentPage == "settingsScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Einstellungen",
                  style: TextStyle(
                    color: Globals.currentPage == "settingsScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if(Globals.currentPage != "settingsScreen") {
                    String prevPage = Globals.currentPage;
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => SettingsScreen())).then((value) {
                      Globals.currentPage = prevPage;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text("Abmelden",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _logout();
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline, color: Globals.currentPage == "helpScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Hilfe",
                  style: TextStyle(
                    color: Globals.currentPage == "helpScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline, color: Globals.currentPage == "impressumScreen" ? Color(0xff00b1ac) : Colors.white,),
                title: Text("Impressum",
                  style: TextStyle(
                    color: Globals.currentPage == "impressumScreen" ? Color(0xff00b1ac) : Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(Globals.currentUser is StudentObject) {
      return studentDrawer();
    } else {
      return professorDrawer();
    }
  }
}