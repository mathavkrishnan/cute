import 'package:flutter/material.dart';
import 'HomeBook.dart';
import 'Profile.dart';

class Trackride extends StatefulWidget {
  const Trackride({Key? key}) : super(key: key);

  @override
  State<Trackride> createState() => _TrackrideState();
}

class _TrackrideState extends State<Trackride> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your rides",style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Center(
                child: Image(image: AssetImage("assets/images/car.png"),),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeBook()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person,
              ),
              title: const Text('Your profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.car_crash,
              ),
              title: const Text('Track your ride'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Trackride()));
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Please wait! Once your ride is conformed you will get notified in message or in notification and ride will be listed here",style: TextStyle(fontSize: 20),),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: MediaQuery. of(context). size. width,
                    height: MediaQuery. of(context). size. height/4,
                    decoration: BoxDecoration(
                        color: Colors.black
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Center(child: Text("A")),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Pick up",style: TextStyle(color: Colors.white),),
                                IconButton(onPressed: ()=>{}, icon: CircleAvatar(
                                  backgroundColor: Colors.white,
                                    child: Icon(Icons.arrow_forward_sharp,color: Colors.black,size: 25,)),)
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Boston USA happy",style: TextStyle(color: Colors.white,fontSize: 20),)
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Center(child: Text("A")),
                              ),
                            ),
                            Text("Drop off",style: TextStyle(color: Colors.white),)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Boston USA happy",style: TextStyle(color: Colors.white,fontSize: 20),)
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: MediaQuery. of(context). size. width,
                    height: MediaQuery. of(context). size. height/4,
                    decoration: BoxDecoration(
                        color: Colors.black
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Center(child: Text("A")),
                              ),
                            ),
                            Text("Pick up",style: TextStyle(color: Colors.white),)
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Boston USA happy",style: TextStyle(color: Colors.white,fontSize: 20),)
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Center(child: Text("A")),
                              ),
                            ),
                            Text("Drop off",style: TextStyle(color: Colors.white),)
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Boston USA happy",style: TextStyle(color: Colors.white,fontSize: 20),)
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
