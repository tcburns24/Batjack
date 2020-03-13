import 'package:blacktom/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  SignIn({this.toggleView});
  final Function toggleView;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = new AuthService();

  String email = '';
  String password = '';
  String errorText = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 6.0,
        title: Text('Sign in'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () => widget.toggleView(),
              icon: Icon(
                Icons.featured_video,
                color: Colors.white10,
              ),
              label: Text(
                'Register',
                style: TextStyle(color: Colors.white10),
              ))
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                TextFormField(
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) => val.isEmpty ? 'Enter your email, dumbass' : null,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  validator: (val) => val.length < 6 ? 'Password\'s gotta be 6+ characters' : null,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  color: Colors.blueAccent[700],
                  textColor: Colors.white,
                  child: Text('Sign in'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if (result == null) {
                        setState(() {
                          errorText = 'No existing user w/ those credentials';
                        });
                      }
                    }
                  },
                ),
                SizedBox(height: 12),
                Text(errorText, style: TextStyle(color: Colors.red, fontFamily: 'Avenir')),
              ],
            ),
          )),
    );
  }
}
