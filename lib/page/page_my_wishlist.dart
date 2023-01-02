import 'package:flutter/material.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class Test {
  FlutterLogo img;
  bool reservation;
  String giver;
  String product;
  num price;
  bool check;
  bool gift;

  Test(
      {required this.img,
      required this.reservation,
      required this.giver,
      required this.check,
      required this.product,
      required this.price,
      required this.gift});
}

class _WishListState extends State<WishList> {
  // 차후에는 firebase에서 데이터 받아서 리스트 생성
  final List<Test> tests = [
    Test(
      img: FlutterLogo(),
      giver: "영희",
      product: '아이폰',
      price: 300000,
      reservation: true,
      check: false,
      gift: false,
    ),
    Test(
      img: FlutterLogo(),
      giver: "",
      product: '에어팟',
      price: 130000,
      reservation: false,
      check: false,
      gift: false,
    ),
    Test(
      img: FlutterLogo(),
      giver: "현진",
      product: '지갑',
      price: 250000,
      reservation: true,
      check: false,
      gift: false,
    ),
    Test(
      img: FlutterLogo(),
      giver: "준호",
      product: '세탁기',
      price: 700000,
      reservation: true,
      check: false,
      gift: false,
    ),
    Test(
      img: FlutterLogo(),
      giver: "철수",
      product: '애플펜슬',
      price: 11000,
      reservation: false,
      check: false,
      gift: true,
    ),
    Test(
      img: FlutterLogo(),
      giver: "둘리",
      product: '노래방 마이크',
      price: 50000,
      reservation: true,
      check: true,
      gift: true,
    ),
    Test(
      img: FlutterLogo(),
      giver: "나나",
      product: '유모차',
      price: 650000,
      reservation: false,
      check: true,
      gift: true,
    ),
    Test(
      img: FlutterLogo(),
      giver: "또치",
      product: '가방',
      price: 500000,
      reservation: true,
      check: true,
      gift: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      child: Column(
        children: [
          Container(
            width: 350,
            height: 50,
            margin: EdgeInsets.only(right: 30),
            alignment: Alignment.center,
            child: OutlinedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("메세지와 함께 공유하기"),
                    Icon(Icons.share),
                  ],
                ),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                )),
          ),
          Column(
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
                              child: Container(
                                  padding: EdgeInsets.only(top: 10, right: 5),
                                  child: Text(
                                    i.giver + '님이 선물 예약하셨어요.',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  width: 370,
                                  height: 40,
                                  color: Colors.black.withOpacity(0.5))),
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
                                      margin:
                                          EdgeInsets.only(left: 40, top: 30)),
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
                                        i.giver + '님께 선물을 받았어요.',
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
                                          margin: EdgeInsets.only(
                                              left: 40, top: 30)),
                                    ],
                                  )),
                            ],
                          ),
                        )
                      // 선물 받음 체크 안한 상태
                      : i.gift == true
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
                                              padding: EdgeInsets.only(
                                                  top: 10, right: 70),
                                              child: Text(
                                                i.giver + '님이 선물을 보냈어요',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              width: 370,
                                              height: 40,
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ],
                                      )),
                                  Positioned(
                                      bottom: 5,
                                      right: 0,
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        child: Text("받음"),
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
                                            margin: EdgeInsets.only(
                                                left: 40, top: 20),
                                          ),
                                          Container(
                                              child: Text(
                                                "${i.price}원",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              margin: EdgeInsets.only(
                                                  left: 40, top: 30)),
                                        ],
                                      )),
                                ],
                              ),
                            )
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
                                            margin: EdgeInsets.only(
                                                left: 40, top: 20),
                                          ),
                                          Container(
                                              child: Text(
                                                "${i.price}원",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              margin: EdgeInsets.only(
                                                  left: 40, top: 30)),
                                        ],
                                      )),
                                ],
                              ),
                            ),
            );
          }).toList()),
        ],
      ),
    ));
  }
}
