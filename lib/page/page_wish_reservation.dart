import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Reservation extends StatefulWidget {
  const Reservation({Key? key}) : super(key: key);

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("예약 화면"),
      ),
      body: SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('임시 텍스트',
                  textAlign: TextAlign.center,
                  style:TextStyle(fontSize: 30,backgroundColor: Colors.white),
              ),
            ],
          ),
        ),
    );
  }
}
