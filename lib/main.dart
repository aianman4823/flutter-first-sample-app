import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(color: Colors.white);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(color: Colors.blue);
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyAuthPage(),
    );
  }
}

class MyAuthPage extends StatefulWidget {
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

class _MyAuthPageState extends State<MyAuthPage> {
  String newUserEmail = "";
  String newUserPassword = "";

  String loginUserEmail = "";
  String loginUserPassword = "";

  String infoText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ユーザ認証'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  setState(() {
                    newUserEmail = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード(6文字以上)"),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    newUserPassword = value;
                  });
                },
              ),
              RaisedButton(
                onPressed: () async {
                  try {
                    // final FirebaseAuth auth = FirebaseAuth.instance;
                    // final UserCredential result =
                    //     await auth.createUserWithEmailAndPassword(
                    //   email: newUserEmail,
                    //   password: newUserPassword,
                    // );

                    User user = (await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: newUserEmail, password: newUserPassword))
                        .user;
                    setState(() {
                      infoText = "登録OK: ${user.email}";
                    });
                  } catch (e) {
                    setState(() {
                      infoText = "登録NG: ${e.message}";
                    });
                  }
                  print(infoText);
                },
                child: Text("ユーザー登録"),
              ),
              Container(
                height: 32,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  setState(() {
                    loginUserEmail = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード"),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    loginUserPassword = value;
                  });
                },
              ),
              RaisedButton(
                onPressed: () async {
                  try {
                    // final FirebaseAuth auth = FirebaseAuth.instance;
                    // final UserCredential result =
                    //     await auth.signInWithEmailAndPassword(
                    //   email: loginUserEmail,
                    //   password: loginUserPassword,
                    // );

                    User user = (await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: loginUserEmail,
                                password: loginUserPassword))
                        .user;
                    setState(() {
                      infoText = "ログインOK: ${user.email}";
                    });
                  } catch (e) {
                    setState(() {
                      infoText = "ログインNG: ${e.message}";
                    });
                  }
                },
                child: Text('ログイン'),
              ),
              Container(child: Text(infoText)),
            ],
          ),
        ),
      ),
    );
  }
}
