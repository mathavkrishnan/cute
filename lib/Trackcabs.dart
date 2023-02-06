import 'package:flutter/material.dart';
import 'HomeBook.dart';

class Trackcabs extends StatefulWidget {
  const Trackcabs({Key? key}) : super(key: key);

  @override
  State<Trackcabs> createState() => _TrackcabsState();
}

class _TrackcabsState extends State<Trackcabs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text("Tracking\nYour vehicle"),
                    ],
                  ),
                  MaterialButton(
                    onPressed: ()=>HomeBook(),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(40))
                      ),
                      child: Icon(Icons.call,color: Colors.white,size: 20,)
                    ),
                  )
                ],
              ),
              Text("(Est 5 mins)"),
            ],
          ),
        ),
      ),
    );
  }
}
