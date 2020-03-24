import 'package:blacktom/services/auth.dart';
import 'package:blacktom/shared/loading.dart';
import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  SignIn({this.toggleView});
  final Function toggleView;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
    return Scaffold(
      backgroundColor: BatmanColors.blueGrey,
      appBar: AppBar(
        backgroundColor: BatmanColors.darkGrey,
        elevation: 6.0,
        title: Text('Sign In'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 12),
                  child: Image.asset('assets/batman_logos/white.png', height: batLogoHeight, width: batLogoWidth),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: Container(
                        child: Text('Sign in to Batjack', style: GoogleFonts.oxanium(fontSize: 20, color: Colors.white)))),
                TextFormField(
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  style: GoogleFonts.oxanium(color: Colors.white),
                  validator: (val) => !_isValidEmail(val) ? 'You sure about that? 👆🏼' : null,
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
                    labelStyle: GoogleFonts.oxanium(color: BatmanColors.lightGrey),
                    errorStyle: GoogleFonts.oxanium(color: Colors.orangeAccent),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  style: GoogleFonts.oxanium(color: Colors.white),
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
                    labelStyle: GoogleFonts.oxanium(color: BatmanColors.lightGrey),
                    errorStyle: GoogleFonts.oxanium(color: Colors.orangeAccent),
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? Padding(padding: EdgeInsets.only(top: 6), child: Loading())
                    : RaisedButton(
                        color: BatmanColors.black,
                        textColor: Colors.white,
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Sign In', style: GoogleFonts.oxanium(fontWeight: FontWeight.w600))),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)), side: BorderSide(color: BatmanColors.black)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                errorText = 'That\'s not your password. Hopefully Alfred wrote it on a post-it note.';
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
                      child: Text('New to Batjack? Sign up here.', style: GoogleFonts.oxanium(color: Colors.white)),
                      onTap: () => widget.toggleView(),
                    )))
              ],
            ),
          )),
    );
  }
}
