import 'package:cutie/Trackride.dart';
import 'package:flutter/material.dart';

class Ridedetail extends StatefulWidget {
  const Ridedetail({Key? key}) : super(key: key);
  @override
  State<Ridedetail> createState() => _RidedetailState();
}

class _RidedetailState extends State<Ridedetail> {
  @override
  void initState() {
    super.initState();
  }

  static List<String> vehicles = ["taxi","auto","ev","parcel"];
  List<String> price = ["10","30","20","10"];
  var i = 0;
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
                  Text("Souce destination eg chennai"),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text("B"),
                        Text("Drop off")
                      ],
                    ),
                  ),

                  Text("Destination name"),
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
                        child: Center(child: Text("Pay 100",style: TextStyle(color: Colors.white),)),
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
