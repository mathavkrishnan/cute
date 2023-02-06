import 'dart:convert';
import 'package:cutie/HomeBook.dart';
import 'package:cutie/Trackride.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pay/pay.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import 'Trackcabs.dart';

class Ridedetail extends StatefulWidget {
  const Ridedetail({Key? key}) : super(key: key);
  static Position? source;
  static String? dest;
  static LatLng? spos;
  static num? dst;
  static String? phno;
  @override
  State<Ridedetail> createState() => _RidedetailState();
}

class _RidedetailState extends State<Ridedetail> {
  @override
  bool _isLoading=false;
  Map<String, dynamic>? paymentIntent;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String src = "";
  double lat = 0.0;
  double lon = 0.0;
  void initState() {
    setlocation();
    super.initState();
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent((int.parse(price[i])*(Ridedetail.dst!)).toString(), 'IND');
      //STEP 2: Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'], //Gotten from payment intent
              style: ThemeMode.dark,
              merchantDisplayName: 'MAGICSTEP')).then((value) {});
      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100.0,
                  ),
                  SizedBox(height: 10.0),
                  //redirect to driver page
                  Text("Succesful payment")
                ],
              ),
            ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
      await _firestore.collection('rides').add({
        'myloc':GeoPoint(lat,lon),
        'riderno':0,
        'ridetaken':false,
        'theirloc':GeoPoint(0,0),
        'yourno':Ridedetail.phno
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeBook()));
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': 'INR',
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51MX2u2SBGTsUxosHprqyNXmH8atoHIYVzPtu1c6VZc77PEiMt49vsuiiymbUFLQnXNlysGpfeOvRcdvHhYNbRhOD00r8bz6yYJ',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(price[i])*(Ridedetail.dst!)) * 100;
    return calculatedAmout.toString();
  }

  setlocation()async{
    print(Ridedetail.source);
    double lat = Ridedetail.source!.latitude;
    double long = Ridedetail.source!.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(lat,long);
    print(placemarks[0]);
    setState(() {
      src = placemarks[0].name!;
      this.lat = lat;
      this.lon = long;
    });
    print(src);
  }

  static List<String> vehicles = ["taxi","auto","ev","parcel"];
  List<String> price = ["10","30","20","10"];
  var i =0;
  var distance = 100;
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: MediaQuery. of(context).size.width,
              height: MediaQuery. of(context).size.height/2.5,
              decoration: BoxDecoration(
                  color: Colors.black
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text("Book now",style: TextStyle(color: Colors.white),),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(onPressed: ()=>{
                                setState((){
                                  if(i<=0){
                                    i = 3;
                                  }
                                  else{
                                    i--;
                                  }
                                })
                              },
                                  icon: Icon(Icons.arrow_back,color: Colors.black,))),
                          Image(image: AssetImage("assets/images/${vehicles[i]}.png"),height: MediaQuery. of(context).size.height/3.5,width: MediaQuery. of(context).size.width/1.5,),
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(onPressed: ()=>{
                                setState((){
                                  if(i>=3){
                                    i = 0;
                                  }
                                  else{
                                    i++;
                                  }
                                })
                              }, icon: Icon(Icons.arrow_forward,color: Colors.black,))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text(vehicles[i][0].toUpperCase()+vehicles[i].substring(1)),
            Text("(Will be arrived in 15min)"),
            Container(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text("A"),
                        Text("Pick up")
                      ],
                    ),
                  ),
                  Text(src),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text("B"),
                        Text("Drop off")
                      ],
                    ),
                  ),

                  Text(Ridedetail.dest.toString()),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: MaterialButton(
                      onPressed: ()async=>{
                        /*await makePayment(),*/
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Trackride()))
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.black
                        ),
                        child: Center(child: Text("Pay "+(int.parse(price[i])*(Ridedetail.dst!)).toString(),style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
