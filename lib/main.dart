import 'package:firebase_core/firebase_core.dart'; // ✅ Add this import
import 'package:blacktom/screens/wrapper.dart';
import 'package:blacktom/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();         // ✅ Required before Firebase init
  await Firebase.initializeApp();                    // ✅ Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return StreamProvider<AppUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        theme: ThemeData(
          textTheme: TextTheme(
            bodyLarge: GoogleFonts.oxanium(),
          ),
        ),
      ),
    );
  }
}
