import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:blacktom/screens/wrapper.dart';
import 'package:blacktom/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAsVr3AiSWb8YpvEBstSTWAsqzz3tQw5f8",
        authDomain: "blacktom-549a8.firebaseapp.com",
        databaseURL: "https://blacktom-549a8.firebaseio.com",
        projectId: "blacktom-549a8",
        storageBucket: "blacktom-549a8.firebasestorage.app",
        messagingSenderId: "599063975211",
        appId: "1:599063975211:web:20684546ddfbca2386e16e"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

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
