import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'HomeBook.dart';

class Otpverify extends StatefulWidget {
  const Otpverify({Key? key}) : super(key: key);
  static String verify = "";
  @override
  State<Otpverify> createState() => _OtpverifyState();
}

class _OtpverifyState extends State<Otpverify> {
  @override
  FirebaseAuth auth = FirebaseAuth.instance;
  String smscode = "";
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Otp\nverification",style: TextStyle(fontSize: 34),),
                  SizedBox(height: 40,),
                  Text("6 digit code has been sent to your mobile number  \n+91-99999 99999"),
                  SizedBox(height: 40,),
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: Color(0xFF512DA8),
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: true,
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      //handle validation or checks here
                    },
                    //runs when every textfield is filled
                    onSubmit: (String sms){
                      smscode = sms;
                    }, // end onSubmit
                  ),
                  SizedBox(height: 40,),
                  Text("Didn’t receive the code? Request Again"),
                  SizedBox(height: 40,),
                ],
              ),
              Center(
                child: MaterialButton(
                  onPressed: () async {
                        try{
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: Otpverify.verify, smsCode: smscode);
                          await auth.signInWithCredential(credential);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeBook()));
                        }
                        catch(e){
                          print("wrong otp");
                        }
                  },
                  child: Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.black
                    ),
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Contine",style: TextStyle(color: Colors.white),),
                            Icon(Icons.arrow_forward_sharp,color: Colors.white,),
                          ],
                        )),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
