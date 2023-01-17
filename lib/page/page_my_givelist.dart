import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:wewish/model/item_give.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:url_launcher/url_launcher.dart';

class GiveList extends StatefulWidget {
  List<GiveItem> giveList;

  GiveList(this.giveList, {Key? key}) : super(key: key);

  @override
  State<GiveList> createState() => _GiveListState();
}

class _GiveListState extends State<GiveList> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
                child: Column(
                    children: widget.giveList.map((i) {
                  // reservation과 check의 bool 값에 따라서 분기를 나누려한다.
                  return SizedBox(
                    width: 400,
                    height: 180,
                    child: i.isBooked == true // 예약 상태
                        ? _buildReservationStatusSizebox(i)
                        // 예약 상태가 아님
                        : i.isChecked == true // 선물 받음 체크 한 상태
                            ? _buildCheckStatusSizebox(i)
                            // 선물 받음 체크 안한 상태
                            : i.isSended == true
                                ? _buildBeforeCheckStatusSizebox(i)
                                : _buildAnyStatusSizebox(i),
                  );
                }).toList()));
  }

  Widget _buildProductImgSizebox(String url) {
    // 이미지 widget
    return Positioned(
      top: 10,
      left: 0,
      child: SizedBox(width: 150, height: 130, child: Image.network(url)),
    );
  }

  Widget _buildProductInfo(String product_name) {
    // 상품 이름과 가격 widget
    return Positioned(
        top: 0,
        right: 30,
        child: Column(
          children: [
            Container(
              child: Text(
                product_name,
                style: TextStyle(fontSize: 13),
              ),
              margin: EdgeInsets.only(left: 40, top: 20),
            ),
          ],
        ));
  }

  Widget _buildDescribe(String receiver, String describe, double _height,
      double _top, double _right) {
    return Positioned(
        bottom: 0,
        left: 0,
        child: Container(
            padding: EdgeInsets.only(top: _top, right: _right),
            child: Text(
              receiver + describe,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white),
            ),
            width: 370,
            height: _height,
            color: Colors.black.withOpacity(0.5)));
  }

  // 선물 받음 체크받은 상태
  Widget _buildCheckStatusSizebox(user_data) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: Colors.black,
      )),
      margin: EdgeInsets.only(top: 30, right: 30),
      child: Stack(
        children: [
          _buildDescribe(user_data.receiver, '님께 선물을 받았어요.', 200, 170, 5),
          _buildProductImgSizebox(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNYfI9jg0TRgOlwhYgZaJvj_-zl8uhfpcqMw&usqp=CAU'),
          _buildProductInfo(user_data.productName),
        ],
      ),
    );
  }

  Widget _buildReservationStatusSizebox(user_data) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: Colors.black,
      )),
      margin: EdgeInsets.only(top: 30, right: 30),
      child: Stack(
        children: [
          _buildDescribe(user_data.receiver, '님이 선물을 예약하셨어요.', 40, 10, 5),
          _buildProductImgSizebox(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNYfI9jg0TRgOlwhYgZaJvj_-zl8uhfpcqMw&usqp=CAU'),
          _buildProductInfo(user_data.productName),
        ],
      ),
    );
  }

  // 아무 상태 없을 때
  Widget _buildAnyStatusSizebox(user_data) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: Colors.black,
      )),
      margin: EdgeInsets.only(top: 30, right: 30),
      child: Stack(
        children: [
          _buildProductImgSizebox(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNYfI9jg0TRgOlwhYgZaJvj_-zl8uhfpcqMw&usqp=CAU'),
          _buildProductInfo(user_data.productName),
        ],
      ),
    );
  }

  Widget _buildBeforeCheckStatusSizebox(user_data) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: Colors.black,
      )),
      margin: EdgeInsets.only(top: 30, right: 30),
      child: Stack(
        children: [
          _buildDescribe(user_data.receiver, '님이 선물을 보냈어요.', 40, 10, 70),
          Positioned(
              bottom: 5,
              right: 0,
              child: OutlinedButton(
                onPressed: () {},
                child: Text("받음"),
                style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)))),
              )),
          _buildProductImgSizebox(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNYfI9jg0TRgOlwhYgZaJvj_-zl8uhfpcqMw&usqp=CAU'),
          _buildProductInfo(user_data.productName),
        ],
      ),
    );
  }
}
