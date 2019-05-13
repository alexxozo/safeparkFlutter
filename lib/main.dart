import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new LoginPage(),
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ));
  }
}

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

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
      body: new Stack(
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
                                labelText: "Enter Your E-mail:"),
                            keyboardType: TextInputType.emailAddress),
                        new TextFormField(
                          decoration: new InputDecoration(
                              labelText: "Enter Your Password:"),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        new Padding(padding: const EdgeInsets.only(top: 40.0)),
                        new MaterialButton(
                            minWidth: 100.0,
                            height: 45.0,
                            color: Colors.teal,
                            textColor: Colors.white,
                            child: new Text("Login"),
                            onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchPage())),
                                },
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
                            onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage())),
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
      ),
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
      body: new Stack(
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
                                labelText: "Enter Your E-mail:"),
                            keyboardType: TextInputType.emailAddress),
                        new TextFormField(
                          decoration: new InputDecoration(
                              labelText: "Enter Your Password:"),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        new TextFormField(
                            decoration: new InputDecoration(
                                labelText: "Enter Your Plate Number:"),
                            keyboardType: TextInputType.text),
                        new Padding(padding: const EdgeInsets.only(top: 40.0)),
                        new MaterialButton(
                            minWidth: 100.0,
                            height: 45.0,
                            color: Colors.teal,
                            textColor: Colors.white,
                            child: new Text("Register now!"),
                            onPressed: () => {},
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
      body: new Stack(
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
                            keyboardType: TextInputType.text),
                        new Padding(padding: const EdgeInsets.only(top: 40.0)),
                        new MaterialButton(
                            minWidth: 100.0,
                            height: 45.0,
                            color: Colors.teal,
                            textColor: Colors.white,
                            child: new Text("Search!"),
                            onPressed: () => {},
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
    );
  }
}
