import 'package:blacktom/services/auth.dart';
import 'package:blacktom/shared/loading.dart';
import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            backgroundColor: BatmanColors.lightGrey,
            appBar: AppBar(
              backgroundColor: BatmanColors.darkGrey,
              elevation: 6.0,
              title: Text('Sign up'),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: Container(child: Text('Sign up for Batjack', style: GoogleFonts.oxanium(fontSize: 20)))),
                      TextFormField(
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (val) => val.isEmpty ? 'Enter your email, dumbass' : null,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(color: BatmanColors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(color: BatmanColors.black),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          labelText: 'Email',
                          labelStyle: GoogleFonts.oxanium(color: BatmanColors.yellow),
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
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(color: BatmanColors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(color: BatmanColors.black),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          labelText: 'Password',
                          labelStyle: GoogleFonts.oxanium(color: BatmanColors.yellow),
                        ),
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                        color: BatmanColors.black,
                        textColor: BatmanColors.yellow,
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
                      Text(errorText, style: GoogleFonts.oxanium(color: Colors.orange)),
                      Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Container(
                              child: GestureDetector(
                            child: Text('Already signed up? Log in here.', style: GoogleFonts.oxanium()),
                            onTap: () => widget.toggleView(),
                          )))
                    ],
                  ),
                )),
          );
  }
}
