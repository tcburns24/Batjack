import 'package:blacktom/services/auth.dart';
import 'package:blacktom/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  Register({this.toggleView});
  final Function toggleView;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = new AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String errorText = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.green[900],
              elevation: 6.0,
              title: Text('Sign up'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () => widget.toggleView(),
                    icon: Icon(
                      Icons.featured_video,
                      color: Colors.white10,
                    ),
                    label: Text('Sign In', style: TextStyle(color: Colors.white10)))
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
                        child: Text('Sign up'),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                errorText = 'Try again';
                                isLoading = false;
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
