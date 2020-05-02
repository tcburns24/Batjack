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

  String validEmailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  bool _isValidEmail(String email) {
    RegExp regex = new RegExp(validEmailRegex);
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    num batLogoWidth = MediaQuery.of(context).size.width / 2;
    num batLogoHeight = batLogoWidth * 0.6;
    return isLoading
        ? Loading(bgColor: Colors.black, dotColor: BatmanColors.yellow)
        : Scaffold(
            backgroundColor: BatmanColors.lightGrey,
            appBar: AppBar(
              backgroundColor: BatmanColors.darkGrey,
              elevation: 6.0,
              title: Text('Sign Up'),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 12),
                          child: Image.asset('assets/batman_logos/yellow_bg.png', height: batLogoHeight, width: batLogoWidth),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 12),
                            child: Container(child: Text('Sign up for Batjack', style: GoogleFonts.oxanium(fontSize: 20)))),
                        TextFormField(
                          style: GoogleFonts.oxanium(color: BatmanColors.yellow),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          validator: (val) =>
                              !_isValidEmail(val) ? 'You underestimate Batcave security. Enter a real email.' : null,
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
                              borderSide: BorderSide(color: Colors.orangeAccent),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: Colors.orangeAccent),
                            ),
                            labelText: 'Email',
                            labelStyle: GoogleFonts.oxanium(color: BatmanColors.darkGrey),
                            errorStyle: GoogleFonts.oxanium(color: Colors.orangeAccent),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: GoogleFonts.oxanium(color: BatmanColors.yellow),
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
                              borderSide: BorderSide(color: Colors.orangeAccent),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: Colors.orangeAccent),
                            ),
                            labelText: 'Password',
                            labelStyle: GoogleFonts.oxanium(color: BatmanColors.darkGrey),
                            errorStyle: GoogleFonts.oxanium(color: Colors.orangeAccent),
                          ),
                        ),
                        SizedBox(height: 20),
                        isLoading
                            ? Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Loading(
                                  bgColor: Colors.black,
                                  dotColor: BatmanColors.yellow,
                                ))
                            : RaisedButton(
                                color: BatmanColors.black,
                                textColor: BatmanColors.yellow,
                                child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text('Sign Up', style: GoogleFonts.oxanium(fontWeight: FontWeight.w600))),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    side: BorderSide(color: BatmanColors.black)),
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
                        Text(errorText, style: GoogleFonts.oxanium(color: Colors.orangeAccent)),
                        Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Container(
                                child: GestureDetector(
                              child: Text('Already signed up? Log in here.', style: GoogleFonts.oxanium(color: Colors.white)),
                              onTap: () => widget.toggleView(),
                            )))
                      ],
                    ),
                  ),
                )),
          );
  }
}
