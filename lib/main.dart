import 'package:cutie/HomeBook.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Signup.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  bool showspinner = false;
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width ;
    double height = MediaQuery. of(context). size. height;
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(300))
                    ),
                    child: Image(image: AssetImage('assets/images/car.png'))
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
                          padding: const EdgeInsets.all(5.0),
                          child: MaterialButton(
                            textColor: Colors.white,
                            elevation: 8.0,
                            onPressed: ()=>{
                              setState((){
                                showspinner = true;
                              }),
                              FirebaseAuth.instance.authStateChanges().listen((User? user) {
                                if (user == null) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                                  setState((){
                                    showspinner = false;
                                  });
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeBook()));
                                setState((){
                                  showspinner = false;
                                });
                                }
                              }),
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
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
                                    Text("Get started"),
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
          )
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
