import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/services/web_service.dart';


class AuthService {
  var currentUser;
  DatabaseService dbService;
  WebService webService;

  AuthService() {
    dbService = DatabaseService.instance;
    webService = WebService.instance;
    dbService.database;
    print("new AuthService");
  }

  Future getUser() {
    return currentUser;
  }

  Future logout() {
    this.currentUser = null;
    Globals.currentUser = null;
    Globals.oldEventStatusMap = LinkedHashMap();
    Globals.isLoggedIn = false;
    webService.closeWebSocket();
    return currentUser;
  }

  Future<bool> login(String username, String password, BuildContext context) async {
    print("in login authService");
    var user = await webService.login(username, password, context);
      if(user == null) {
        this.currentUser = null;
        return false;
      }
      this.currentUser = {'username': username};
      Globals.currentUser = user;
      return true;
  }
}