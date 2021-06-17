
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/objects/professor_object.dart';
import 'package:studybuddy/objects/student_object.dart';
import 'package:studybuddy/services/blockchain_service.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/services/auth_service.dart';

import 'main_professor_screen.dart';
import 'main_student_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    Key key,
  }) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  bool _saveLogin = false;
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  String _username;
  String _password;
  bool once = true;
  DatabaseService dbService = DatabaseService.instance;
  BlockchainService blockchain = BlockchainService.instance;
  AuthService authService = AuthService();

  AnimationController _controller;

  Widget _usernameField() {
    return Container(
      width: ResponsiveFlutter.of(context).wp(80),
      child: TextFormField(
        controller: _usernameController,
        maxLines: 1,
        validator: (value) =>
            value.isEmpty ? 'Der Nutzername darf nicht leer sein' : null,
        autofocus: false,
        onSaved: (value) => _username = value.trim(),
        obscureText: false,
        decoration: InputDecoration(
          labelText: "FH-Kennung",
          suffixIcon: Container(
            margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
            height: 20.0,
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
              onPressed: () {
                _usernameController.clear();
              },
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
          hintText: 'Geben Sie Ihren Benutzernamen ein...',
          hintStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 15,
          color: const Color(0xff3f3d56),
        ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      width: ResponsiveFlutter.of(context).wp(80),
      child: TextFormField(
        controller: _passwordController,
        maxLines: 1,
        validator: (value) =>
            value.isEmpty ? 'Das Passwort darf nicht leer sein' : null,
        autofocus: false,
        onSaved: (value) => _password = value.trim(),
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          labelText: "Passwort",
          suffixIcon: Container(
            height: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _passwordController.clear();
                  },
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
          hintText: 'Geben Sie Ihr Passwort ein...',
          hintStyle: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            color: const Color(0xff3f3d56),
          ),
        ),
      ),
    );
  }

  void validateAndSubmit() async {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState;
    form.save();
    bool success = false;

    if (form.validate()) {
      success = await authService.login(_username, _password, context);
      Globals.isLoggedIn = success;

      if (success == false) {
        return _buildErrorDialog(context);
      } else {
        storage.write(key: "saveCredentials", value: _saveLogin.toString());
        if (_saveLogin == false) {
          _formKey.currentState?.reset();
          _usernameController.clear();
          _passwordController.clear();
        } else {
          storage.write(key: "username", value: _username);
          storage.write(key: "password", value: _password);
        }
        if (Globals.currentUser is StudentObject) {
          //Student Route
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainStudentScreen()),
          ).then((value) {
            authService.logout();
          });
        } else if (Globals.currentUser is ProfessorObject) {
          //Professor Route
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainProfessorScreen()),
          ).then((value) {
            authService.logout();
          });
        }
      }
    }
  }

  Future _buildErrorDialog(BuildContext context) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text("Login Fehler"),
          content: Text("Der Benutzername oder das Passwort waren falsch"),
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

  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _usernameField(),
          SizedBox(
            height: ResponsiveFlutter.of(context).verticalScale(48.0),
          ),
          _passwordField(),
        ],
      ),
    );
  }

  void checkFromStorage() async {
    String saveCredentials = await storage.read(key: "saveCredentials");
    if (saveCredentials == null || saveCredentials == "false") {
      return;
    }
    String username = await storage.read(key: "username");
    String password = await storage.read(key: "password");
    setState(() {
      _saveLogin = true;
      _usernameController.text = username;
      _passwordController.text = password;
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {
    if (once) {
      once = false;
      checkFromStorage();
      Future.delayed(
          Duration(milliseconds: 2500),
              () =>
                  _controller.forward()
              );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack (
        children: <Widget> [
      ScrollConfiguration(
      behavior: MyBehavior(),
        child: SingleChildScrollView(
        child: Stack(children: <Widget>[
      Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: ResponsiveFlutter.of(context).hp(42.0),
                        alignment: Alignment.topCenter,
                        color: Color(0xff3f3d56),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).scale(32.0), top: ResponsiveFlutter.of(context).verticalScale(64.0)),
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.help_outline, color: Colors.white, size: ResponsiveFlutter.of(context).scale(32),),
                          onPressed: () {
                          },
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: ResponsiveFlutter.of(context).verticalScale(64.0),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(32.0)),
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Anmelden',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: ResponsiveFlutter.of(context).fontSize(5.0), //fontSize: 29
                                color: const Color(0xff19d9d3),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveFlutter.of(context).verticalScale(16.0),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(32.0), 0.0, 0.0, 0.0),
                            child: Text(
                              'Herzlich Willkommen!',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: ResponsiveFlutter.of(context).fontSize(2.0), //fontSize: 17
                                color: const Color(0xfffefeff),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveFlutter.of(context).verticalScale(4.0),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(32.0), 0.0, ResponsiveFlutter.of(context).scale(32.0), 0.0),
                            child: Text(
                              'Der Study Buddy wird Ihnen dabei helfen, Ihre Fortschritte im Verlauf des Studiums im Auge zu behalten. Bitte melden Sie sich mit Ihrer FH-Kennung und dem von Ihnen gewählten Passwort an.',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                color: const Color(0xfffefeff),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(32.0),
                  ),
                  _loginForm(),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(16.0),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(34.0), 0.0, 0.0, 0.0),
                    child: Text(
                      'Passwort vergessen?',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                        color: Color(0xff00b1ac),
                        letterSpacing: -0.3,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(48.0),
                  ),
                  Container(
                    height: ResponsiveFlutter.of(context).verticalScale(48.0),
                    width: ResponsiveFlutter.of(context).wp(80),
                    child: TextButton(
                      style: TextButton.styleFrom(
                      padding: EdgeInsets.all(0.0),
                      ),
                      onPressed: validateAndSubmit,
                      child: Text(
                        'Anmelden',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.0), //fontSize: 17
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(6.0)),
                      color: Color(0xff00b1ac),
                      border: Border.all(width: ResponsiveFlutter.of(context).scale(2.0), color: Color(0xff00b1ac)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ResponsiveFlutter.of(context).wp(80),
                        child: CheckboxListTile(
                            value: _saveLogin,

                            title: Text(
                              'Anmeldedaten speichern',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                color: Color(0xff838388),
                              ),
                            ),
                            checkColor: Colors.white,
                            activeColor: Color(0xff00b1ac),
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (newValue) {
                              setState(() {
                                _saveLogin = newValue;
                              });
                            }),
                      ),
                    ],
                  ),
                ],
              ),
        Container(
          margin: EdgeInsets.fromLTRB(0.0, ResponsiveFlutter.of(context).hp(97), 0.0, 0.0),
          alignment: Alignment.topCenter,
          child: Text(
            '© 2020 FH Aachen - University Of Applied Sciences',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: ResponsiveFlutter.of(context).fontSize(1.2), //fontSize: 12
              color: const Color(0xff3f3d56),
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
]
    ),
          ),
      ),
    SlideTransition(
    position: Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 20.0)).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    ),
    child:Container(
          alignment: Alignment.bottomCenter,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: AngleClipperBottom(context: context),
                  child: Container(
                    height: ResponsiveFlutter.of(context).hp(50) + ResponsiveFlutter.of(context).verticalScale(64.0),
                    color: Color(0xff19d9d3),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: AngleClipperBottom(context: context),
                  child: Container(
                      height: ResponsiveFlutter.of(context).hp(50),
                      color: Color(0xff00b1ac)),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).verticalScale(36.0)),
                child: Transform.rotate(
                  angle: 0.32,
                  child: Text(
                    'Buddy',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: ResponsiveFlutter.of(context).fontSize(8), //fontSize: 60
                      color: const Color(0xff3f3d56),
                      letterSpacing: -2.4,
                      fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
    ),
        SlideTransition(
          position: Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -20.0)).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
          ),
    child:Container(
          alignment: Alignment.topCenter,
          //height: MediaQuery.of(context).size.height / 2 + 128,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                child: ClipPath(
                  clipper: AngleClipperTop(context: context),
                  child: Container(
                    height: ResponsiveFlutter.of(context).hp(50) + ResponsiveFlutter.of(context).verticalScale(64.0),
                    color: Color(0xff3f3d56),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: ClipPath(
                  clipper: AngleClipperTop(context: context),
                  child: Container(
                      height: ResponsiveFlutter.of(context).hp(50),
                      color: Color(0xff2b2a39)),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).verticalScale(36.0)),
                child: Transform.rotate(
                  angle: 0.32,
                  child: Text(
                    'Study',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: ResponsiveFlutter.of(context).fontSize(8), //fontSize: 60
                      color: const Color(0xff19d9d3),
                      letterSpacing: -2.4,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
             ]
      ),
    );
  }
}

class AngleClipperTop extends CustomClipper<Path> {
  AngleClipperTop({
    this.context,
  }): super();

  BuildContext context;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height - ResponsiveFlutter.of(context).verticalScale(128.0));
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}

class AngleClipperBottom extends CustomClipper<Path> {
  AngleClipperBottom({
    this.context,
}): super();

  BuildContext context;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(size.width, ResponsiveFlutter.of(context).verticalScale(128.0));
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
  BuildContext context, Widget child, AxisDirection axisDirection) {
  return child;
  }
}