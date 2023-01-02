import 'package:flutter/material.dart';

class GiveList extends StatefulWidget {
  const GiveList({Key? key}) : super(key: key);

  @override
  State<GiveList> createState() => _GiveListState();
}

class Test {
  FlutterLogo img;
  bool reservation;
  String receiver;
  String product;
  num price;
  bool check;

  Test({
    required this.img,
    required this.reservation,
    required this.receiver,
    required this.check,
    required this.product,
    required this.price,
  });
}

class _GiveListState extends State<GiveList> {
  final List<Test> tests = [
    Test(
      img: FlutterLogo(),
      receiver: "영희",
      product: '아이폰',
      price: 300000,
      reservation: true,
      check: false,
    ),
    Test(
      img: FlutterLogo(),
      receiver: "소희",
      product: '에어팟',
      price: 130000,
      reservation: false,
      check: true,
    ),
    Test(
      img: FlutterLogo(),
      receiver: "현진",
      product: '지갑',
      price: 250000,
      reservation: true,
      check: false,
    ),
    Test(
      img: FlutterLogo(),
      receiver: "준호",
      product: '세탁기',
      price: 700000,
      reservation: true,
      check: false,
    ),
    Test(
      img: FlutterLogo(),
      receiver: "철수",
      product: '애플펜슬',
      price: 11000,
      reservation: false,
      check: false,
    ),
    Test(
      img: FlutterLogo(),
      receiver: "둘리",
      product: '노래방 마이크',
      price: 50000,
      reservation: true,
      check: true,
    ),
    Test(
      img: FlutterLogo(),
      receiver: "나나",
      product: '유모차',
      price: 650000,
      reservation: false,
      check: true,
    ),
    Test(
      img: FlutterLogo(),
      receiver: "또치",
      product: '가방',
      price: 500000,
      reservation: true,
      check: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: tests.map((i) {
        // reservation과 check의 bool 값에 따라서 분기를 나누려한다.
        return SizedBox(
            width: 400,
            height: 180,
            child: i.reservation == true // 예약 상태
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 1,
                      color: Colors.black,
                    )),
                    margin: EdgeInsets.only(top: 30, right: 30),
                    child: Stack(
                      children: [
                        Positioned(
                            bottom: 0,
                            left: 0,
                            child: Row(
                              children: [
                                Container(
                                    padding:
                                        EdgeInsets.only(top: 10, right: 100),
                                    child: Text(
                                      i.receiver + '님의 위시',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    width: 370,
                                    height: 40,
                                    color: Colors.black.withOpacity(0.5)),
                              ],
                            )),
                        Positioned(
                            bottom: 5,
                            right: 0,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text("예약 취소"),
                              style: OutlinedButton.styleFrom(
                                  primary: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(0)))),
                            )),
                        Positioned(
                          top: 10,
                          left: 0,
                          child:
                              SizedBox(width: 150, height: 130, child: i.img),
                        ),
                        Positioned(
                            top: 0,
                            right: 30,
                            child: Column(
                              children: [
                                Container(
                                  child: Text(
                                    i.product,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  margin: EdgeInsets.only(left: 40, top: 20),
                                ),
                                Container(
                                    child: Text(
                                      "${i.price}원",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    margin: EdgeInsets.only(left: 40, top: 30)),
                              ],
                            )),
                      ],
                    ),
                  )
                // 예약 상태가 아님
                : i.check == true // 선물을 받음 체크 한 상태
                    ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 1,
                          color: Colors.black,
                        )),
                        margin: EdgeInsets.only(top: 30, right: 30),
                        child: Stack(
                          children: [
                            Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                    padding:
                                        EdgeInsets.only(top: 170, right: 5),
                                    child: Text(
                                      i.receiver + '님께 선물했어요',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    width: 370,
                                    height: 200,
                                    color: Colors.black.withOpacity(0.5))),
                            Positioned(
                              top: 10,
                              left: 0,
                              child: SizedBox(
                                  width: 150, height: 130, child: i.img),
                            ),
                            Positioned(
                                top: 0,
                                right: 30,
                                child: Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        i.product,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      margin:
                                          EdgeInsets.only(left: 40, top: 20),
                                    ),
                                    Container(
                                        child: Text(
                                          "${i.price}원",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        margin:
                                            EdgeInsets.only(left: 40, top: 30)),
                                  ],
                                )),
                          ],
                        ),
                      )
                    // 선물 받음 체크 안한 상태

                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 1,
                          color: Colors.black,
                        )),
                        margin: EdgeInsets.only(top: 30, right: 30),
                        child: Stack(
                          children: [
                            Positioned(
                                bottom: 0,
                                left: 0,
                                child: Row(
                                  children: [
                                    Container(
                                        padding:
                                            EdgeInsets.only(top: 10, right: 70),
                                        child: Text(
                                          i.receiver + '님께 선물했어요',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        width: 370,
                                        height: 40,
                                        color: Colors.black.withOpacity(0.5)),
                                  ],
                                )),
                            Positioned(
                                bottom: 5,
                                right: 0,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: Text("취소"),
                                  style: OutlinedButton.styleFrom(
                                      primary: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0)))),
                                )),
                            Positioned(
                              top: 10,
                              left: 0,
                              child: SizedBox(
                                  width: 150, height: 130, child: i.img),
                            ),
                            Positioned(
                                top: 0,
                                right: 30,
                                child: Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        i.product,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      margin:
                                          EdgeInsets.only(left: 40, top: 20),
                                    ),
                                    Container(
                                        child: Text(
                                          "${i.price}원",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        margin:
                                            EdgeInsets.only(left: 40, top: 30)),
                                  ],
                                )),
                          ],
                        ),
                      ));
      }).toList()),
    );
  }
}
