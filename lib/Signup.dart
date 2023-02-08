import 'package:cutie/Ridedetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Otpverify.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  void initState(){
    _getCurrentPosition();
  }
  String? selectedValue1;
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Widget build(BuildContext context) {
    var phone = "";
    double width = MediaQuery. of(context). size. width ;
    double height = MediaQuery. of(context). size. height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Log",style: TextStyle(fontSize: 34),),
                    Text("In",style: TextStyle(fontSize: 34),),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Phone number"),
                          SizedBox(height: 10,),
                          Material(
                            elevation: 10.0,
                            shadowColor: Colors.black,
                            child: TextField (
                              keyboardType: TextInputType.phone,
                              onChanged: (value)=>{
                                phone = value
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(5.0),
                                      borderSide: BorderSide(color: Colors.white, width: 3.0))
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Container(
                    width: width,
                    height: 300,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        border: Border.all(
                            color: Colors.grey
                        ),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: MaterialButton(
                            textColor: Colors.white,
                            elevation: 8.0,
                            onPressed: ()async=>{
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: '+91'+phone,
                                verificationCompleted: (PhoneAuthCredential credential) {
                                },
                                verificationFailed: (FirebaseAuthException e) {},
                                codeSent: (String verificationId, int? resendToken) {
                                  Otpverify.verify = verificationId;
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Otpverify()));
                                },
                                codeAutoRetrievalTimeout: (String verificationId) {},
                                ),
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                      color: Colors.black
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Container(
                                width: 94,
                                child: Row(
                                  children: [
                                    Text("Continue"),
                                    Icon(Icons.arrow_forward_sharp)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
