import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:lawwa/feedback.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

class LocationSender extends StatefulWidget {
  @override
  _LocationSenderState createState() => _LocationSenderState();
}

class _LocationSenderState extends State<LocationSender> {
  String _timeString;

  String time = "";
  String _locationMessage = "";
  DateTime now = new DateTime.now();
  final form = GlobalKey<FormState>();
  var newfeedback = UserComment(
    name: '',
  );

  void signIn() async {
    final validate = form.currentState.validate();
    if (!validate) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    form.currentState.save();
    form.currentState.reset();
    //  print(position);

    setState(() {
      time = '${now.hour}:${now.minute}:${now.second}';
      _locationMessage = "${position.latitude}, ${position.longitude}";
    });
    sendSignIn();

    Toast.show("Your location sent successfully", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
  }
  Future<void> sendSignIn() async {
    const url = 'https://lawwa-cba77.firebaseio.com/SingIn.json';
    await http
        .post(
          url,
          body: json.encode({
            'Name': newfeedback.name,
            'Time': _timeString,
            'Location': _locationMessage,
          }),
        )
        .then((_) {});
  }




  void signOut() async {
    final validate = form.currentState.validate();
    if (!validate) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    form.currentState.save();
    form.currentState.reset();
    //  print(position);

    setState(() {
      time = '${now.hour}:${now.minute}:${now.second}';
      _locationMessage = "${position.latitude}, ${position.longitude}";
    });
    sendSignOut();

    Toast.show("Your location sent successfully", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
  }
  Future<void> sendSignOut() async {
    const url = 'https://lawwa-cba77.firebaseio.com/SignOut.json';
    await http
        .post(
          url,
          body: json.encode({
            'Name': newfeedback.name,
            'Time': _timeString,
            'Location': _locationMessage,
          }),
        )
        .then((_) {});
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy \n   hh:mm:ss').format(dateTime);
  }

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          elevation: 0,
        ),
        body: Form(
          key: form,
          child:
              // Container(
              //   height: MediaQuery.of(context).size.height,
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //       colors: [Colors.deepPurple[300], Colors.deepPurple[900]],
              //     ),
              //   ),
              //   child:
              SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/lawwaasia_logo.png',
                  height: 120,
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey[200], width: 2.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: Container(
                      margin: EdgeInsets.all(24),
                      padding: EdgeInsets.only(left: 60),
                      child: Text(
                        _timeString,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepPurple[200],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    onSaved: (newValue) {
                      newfeedback = UserComment(name: newValue);
                    },
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter valid Name!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'location : ' + _locationMessage,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      elevation: 4,
                      color: Color(0xffdc3569),
                      onPressed: () async {
                        signIn();
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 30,),
                     RaisedButton(
                      elevation: 4,
                      color: Color(0xffdc3569),
                      onPressed: () async {
                        signOut();
                      },
                      child: Text(
                        "Sign Out",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
