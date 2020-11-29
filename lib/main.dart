import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'Location_sender.dart';

void main() {
  runApp(MyApp());
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
      home: MyHomePage(title: 'Lawwa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication auth = LocalAuthentication();
  //bool _canCheckBiometrics;
  // List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  // Future<void> _checkBiometrics() async {
  //   bool canCheckBiometrics;
  //   try {
  //     canCheckBiometrics = await auth.canCheckBiometrics;
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;

  //   setState(() {
  //     _canCheckBiometrics = canCheckBiometrics;
  //   });
  // }

  // Future<void> _getAvailableBiometrics() async {
  //   List<BiometricType> availableBiometrics;
  //   try {
  //     availableBiometrics = await auth.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;

  //   setState(() {
  //     _availableBiometrics = availableBiometrics;
  //   });
  // }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
    if (authenticated == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LocationSender(),
        ),
      );
    } else {
      return;
    }
  }

  // void _cancelAuthentication() {
  //   auth.stopAuthentication();
  // }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () async {
        _authenticate();
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => LocationSender(),
        //   ),
        // );
      },
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment:MainAxisAlignment.spaceEvenly,
          children: [
             Image.asset(
                  'assets/lawwaasia_logo.png',
                  height: 120,
                ),
            Text(
              'Login',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.purple,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.fingerprint,
                  size: 40,
                )),
          ],
        ),
      ),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    );
  }
}
