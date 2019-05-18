import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import './responses.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal/onesignal.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: LoginPage(),
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ));
  }

//  Future<Widget> _getStartupPage() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String token = await prefs.getString('jwt');
//
//    if (token != null) {
//      return SearchPage();
//    } else {
//      return LoginPage();
//    }
//  }
}

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    "username": null,
    "password": null
  };

  @override
  void initState() {
    super.initState();

    initPlatformState();

    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));

    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController.view, curve: Curves.easeOut);

    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  Future<void> _loginUser(BuildContext context) async {
    _formKey.currentState.save();

    print('Login---------');
    try {
      LoginResponse r = await createLoginResponse(body: _formData);

      // Save token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', r.token);

      // Set external player ID instead of the given onesignal ID
      http.Response getID = await http.get('https://safe-park-backend.herokuapp.com/user/getID',
          headers: {HttpHeaders.authorizationHeader: "Bearer " + r.token});

      String externalId = json.decode(getID.body);

      await OneSignal.shared
          .setExternalUserId(externalId);

      final snackBar = SnackBar(
        content: Text('Succesfully logged in!'),
      );
      Scaffold.of(context).showSnackBar(snackBar);

      await Future.delayed(const Duration(seconds: 2));

      // Push search page
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchPage()));
    } catch (ex) {
      final snackBar = SnackBar(
        content: Text(ex.toString().split('Exception:')[1]),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> initPlatformState() async {

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true,
      OSiOSSettings.inAppLaunchUrl : true
    };

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared
        .init("24dae07a-52c3-4fdc-91c3-e77929446319", iOSSettings: settings);

    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Builder(
        builder: (context) =>
          new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image(
                  image: new AssetImage("assets/SafePark.jpg"),
                  fit: BoxFit.cover,
                  color: Colors.black87,
                  colorBlendMode: BlendMode.darken),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new FlutterLogo(
                    size: _iconAnimation.value * 100,
                  ),
                  new Form(
                    key: _formKey,
                    child: new Theme(
                      data: new ThemeData(
                          brightness: Brightness.dark,
                          primarySwatch: Colors.teal,
                          inputDecorationTheme: new InputDecorationTheme(
                              labelStyle: new TextStyle(
                                  color: Colors.teal, fontSize: 20.0))),
                      child: new Container(
                        padding: const EdgeInsets.all(40.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new TextFormField(
                              decoration: new InputDecoration(
                                  labelText: "Enter Your Username:"),
                              keyboardType: TextInputType.emailAddress,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Username Field can't be empty";
                                }
                              },
                              onSaved: (String value) {
                                _formData['username'] = value;
                              },
                            ),
                            new TextFormField(
                              decoration: new InputDecoration(
                                  labelText: "Enter Your Password:"),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              onSaved: (String value) {
                                _formData['password'] = value;
                              },
                            ),
                            new Padding(padding: const EdgeInsets.only(top: 40.0)),
                            new MaterialButton(
                                minWidth: 100.0,
                                height: 45.0,
                                color: Colors.teal,
                                textColor: Colors.white,
                                child: new Text("Login"),
                                onPressed: () => _loginUser(context),
                                splashColor: Colors.redAccent),
                            new Padding(padding: const EdgeInsets.only(top: 120.0)),
                            new Container(
                              alignment: Alignment.center,
                              child: new Text('Dont have an account yet?',
                                  style: new TextStyle(
                                      fontSize: 20.0, color: Colors.white)),
                            ),
                            new Padding(padding: const EdgeInsets.only(top: 20.0)),
                            new MaterialButton(
                                minWidth: 100.0,
                                height: 45.0,
                                color: Colors.teal,
                                textColor: Colors.white,
                                child: new Text("Register now!"),
                                onPressed: ()  {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage()));
                                },
                                splashColor: Colors.redAccent)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          )
      )
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  State createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    "username": null,
    "password": null,
    "plate": null,
    "phone": null
  };

  Future<void> _registerUser(BuildContext context) async {
    _formKey.currentState.save();

    print('Register----------------');
    try {
      await createRegisterResponse(body: _formData);

      Map<String, dynamic> _loginData = {
        "username": _formData["username"],
        "password": _formData["password"]
      };

      print(_loginData);

      LoginResponse r = await createLoginResponse(body: _loginData);

      // Save token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', r.token);

      // Set external player ID instead of the given onesignal ID
      http.Response getID = await http.get('https://safe-park-backend.herokuapp.com/user/getID',
          headers: {HttpHeaders.authorizationHeader: "Bearer " + r.token});

      String externalId = json.decode(getID.body);

      await OneSignal.shared
          .setExternalUserId(externalId);

      final snackBar = SnackBar(
        content: Text('Succesfully registered!'),
      );
      Scaffold.of(context).showSnackBar(snackBar);

      await Future.delayed(const Duration(seconds: 2));

      // Push search page
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchPage()));


    } catch (ex) {
      final snackBar = SnackBar(
        content: Text(ex.toString()),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();

    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));

    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController.view, curve: Curves.easeOut);

    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Builder (
        builder: (context) => new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
                image: new AssetImage("assets/SafePark.jpg"),
                fit: BoxFit.cover,
                color: Colors.black87,
                colorBlendMode: BlendMode.darken),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlutterLogo(
                  size: _iconAnimation.value * 100,
                ),
                new Form(
                  key: _formKey,
                  child: new Theme(
                    data: new ThemeData(
                        brightness: Brightness.dark,
                        primarySwatch: Colors.teal,
                        inputDecorationTheme: new InputDecorationTheme(
                            labelStyle: new TextStyle(
                                color: Colors.teal, fontSize: 20.0))),
                    child: new Container(
                      padding: const EdgeInsets.all(40.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new TextFormField(
                            decoration: new InputDecoration(
                                labelText: "Enter Your Username:"),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String value) {
                              _formData['username'] = value;
                            },
                          ),
                          new TextFormField(
                            decoration: new InputDecoration(
                                labelText: "Enter Your Password:"),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            onSaved: (String value) {
                              _formData['password'] = value;
                            },
                          ),
                          new TextFormField(
                            decoration: new InputDecoration(
                                labelText: "Enter Your Plate Number:"),
                            keyboardType: TextInputType.text,
                            onSaved: (String value) {
                              _formData['plate'] = value;
                            },
                          ),
                          new TextFormField(
                            decoration: new InputDecoration(
                                labelText: "Enter Your Phone Number:"),
                            keyboardType: TextInputType.phone,
                            onSaved: (String value) {
                              _formData['phone'] = value;
                            },
                          ),
                          new Padding(padding: const EdgeInsets.only(top: 40.0)),
                          new MaterialButton(
                              minWidth: 100.0,
                              height: 45.0,
                              color: Colors.teal,
                              textColor: Colors.white,
                              child: new Text("Register now!"),
                              onPressed: () => _registerUser(context),
                              splashColor: Colors.redAccent),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  State createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String username = "";

  final Map<String, dynamic> _formData = {
    "plate": null
  };

  Future<void> _alertUser(BuildContext context) async {
    _formKey.currentState.save();

    print('Alert----------------');
    try {
      await createAlertResponse(body: _formData);

      final snackBar = SnackBar(
        content: Text('Alert succesfully sent!'),
      );
      Scaffold.of(context).showSnackBar(snackBar);

    } catch (ex) {
      final snackBar = SnackBar(
        content: Text(ex.toString()),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt');

    http.Response response = await http.get("https://safe-park-backend.herokuapp.com/user/profile",
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token});

    username = json.decode(response.body)["username"];
  }

  @override
  void initState() {
    super.initState();

    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));

    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController.view, curve: Curves.easeOut);

    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();

    _getUsername();
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Builder(
          builder: (context) => new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image(
                  image: new AssetImage("assets/SafePark.jpg"),
                  fit: BoxFit.cover,
                  color: Colors.black87,
                  colorBlendMode: BlendMode.darken),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new FlutterLogo(
                    size: _iconAnimation.value * 100,
                  ),
                  new Text("Username: " + username,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  new Form(
                    key: _formKey,
                    child: new Theme(
                      data: new ThemeData(
                          brightness: Brightness.dark,
                          primarySwatch: Colors.teal,
                          inputDecorationTheme: new InputDecorationTheme(
                              labelStyle: new TextStyle(
                                  color: Colors.teal, fontSize: 20.0))),
                      child: new Container(
                        padding: const EdgeInsets.all(40.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new TextFormField(
                              decoration: new InputDecoration(
                                  labelText: "Search by Plate Number:"),
                              keyboardType: TextInputType.text,
                              onSaved: (String value) {
                                _formData["plate"] = value;
                              },
                            ),
                            new Padding(padding: const EdgeInsets.only(top: 40.0)),
                            new MaterialButton(
                                minWidth: 100.0,
                                height: 45.0,
                                color: Colors.teal,
                                textColor: Colors.white,
                                child: new Text("Search!"),
                                onPressed: () => _alertUser(context),
                                splashColor: Colors.redAccent),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}
