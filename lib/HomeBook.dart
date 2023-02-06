import 'package:cutie/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Profile.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'Ridedetail.dart';
import 'Trackride.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class HomeBook extends StatefulWidget {
  const HomeBook({Key? key}) : super(key: key);
  static Position? pos;
  @override
  State<HomeBook> createState() => _HomeBookState();
}

class _HomeBookState extends State<HomeBook> {
  @override
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedValue2;
  bool showspinner = false;
  Image? im;
  final TextEditingController textEditingController1 = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();
  @override
  void dispose() {
    textEditingController1.dispose();
    textEditingController2.dispose();
    super.dispose();
  }
  String? selectedValue1;
  void initState(){
    getlocation();
    setState((){
      showspinner = true;
    });
    setState((){
      showspinner = false;
    });
    super.initState();
  }
  Position? _crpos;
  void getlocation()async{
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high).then((Position position) {
           setState(() {
             _crpos = position;
           });
        }).catchError((e) {
      debugPrint(e);
    });
  }
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
  }
  LatLng? pnt;

  Widget build(BuildContext context) {
    num x = MediaQuery. of(context). size. width;
    num y = MediaQuery. of(context). size. height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's ride",style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
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
            ListTile(
              leading: Icon(
                Icons.logout,
              ),
              title: const Text('Logout'),
              onTap: () {
                _signOut();
              },
            ),
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showspinner,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  width: MediaQuery. of(context). size. width,
                  height: MediaQuery. of(context). size. height/7,
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
                          Text("Drop Off",style: TextStyle(color: Colors.white),)
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white
                        ),
                        child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore.collection('places').snapshots(),
                            builder: (context,snapshot) {
                              final itemsr = snapshot.requireData.docs;
                              final List<String> cities = [];
                              List<LatLng> point = [];
                              for(var i in itemsr){
                                final String n = i.get('name');
                                point.add(LatLng(i.get('location').latitude, i.get('location').longitude));
                                cities.add(n);
                              }
                              return DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Text(
                                    'Select Item',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: cities.map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  )).toList(),
                                  value: selectedValue2,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue2 = value as String;
                                      pnt = point[cities.indexOf(selectedValue2!)];
                                    });
                                  },
                                  buttonHeight: 40,
                                  buttonWidth: 200,
                                  itemHeight: 40,
                                  dropdownMaxHeight: 200,
                                  searchController: textEditingController2,
                                  searchInnerWidget: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 4,
                                      right: 8,
                                      left: 8,
                                    ),
                                    child: TextFormField(
                                      controller: textEditingController2,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        hintText: 'Search for an item...',
                                        hintStyle: const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) {
                                    return (item.value.toString().contains(searchValue));
                                  },
                                  //This to clear the search value when you close the menu
                                  onMenuStateChange: (isOpen) {
                                    if (!isOpen) {
                                      textEditingController2.clear();
                                    }
                                  },
                                ),
                              );
                            }
                        ),
                      ),
                      //place map here
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.arrow_forward_sharp),
        backgroundColor: Colors.black,
        onPressed: () {
          Ridedetail.dest = selectedValue2;
          Ridedetail.spos = pnt;
          Ridedetail.dst = 5;
          Ridedetail.source = _crpos;
          print(selectedValue1);
          print(pnt);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Ridedetail()));
        },
      ),
    );
  }
}
