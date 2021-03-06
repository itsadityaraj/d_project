import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:date_time_format/date_time_format.dart';

import '../push_notifications.dart';

class UserData  with ChangeNotifier{
  static final UserData _userdata = UserData._internal();

  factory UserData(){
    return _userdata;
  }

  UserData._internal() {
    checkLoginStatus();
  }

  String userid;
  String name;
  String phoneNo;
  var addressData;
  var orderData;
  int secondsRemainingToCall = 30;


  List<Order> orderList = List<Order>();
  List<Address> addressList = List<Address>();
  Address selectedAddress;

  checkLoginStatus() async {
    PushNotificationsManager pushNotificationsManager = await PushNotificationsManager();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String FIREBASE_TOKEN = "";
    print("WE CAME HERE");
    await _firebaseMessaging.getToken().then((val){
      FIREBASE_TOKEN = val;
      print("FIREBASE TOKEN " + val.toString());
    });




    userid = null;
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    userid = sharedPreferences.getString("token");
    orderList = [];
    addressList = [];
    if(userid != null){
      var url = 'https://purchx.store/api/get_user';
      var response = await http.post(url, body: {
        "user_id" : userid,
        "fcm_token" : FIREBASE_TOKEN,
      });
      var data = json.decode(response.body);
      print(data);
      if(data["error"] != true){
        name = data["user_name"];
        phoneNo = data["phone_number"];
        addressData = data["address"];
        orderData = data["orders"];
        makeAddressList();
        makeOrderList();
      }
    }
  }

  void makeAddressList(){
    if(addressData != null){
      var rest = addressData as List;
      if(rest.length > 0){
        //selectedAddress = addressDat;
        addressList = rest.map<Address>((json) => Address.fromJson(json)).toList();
      }
    }
  }

  void makeOrderList(){
    if(orderData != null){
      var rest = orderData as List;
      if(rest.length > 0){
        orderList = rest.map<Order>((json) => Order.fromJson(json)).toList();
      }
      orderList.sort((Order a, Order b){
        if(DateTime.parse(a.orderTime).isAfter(DateTime.parse(b.orderTime))){
          return -1;
        }
        else{
          return 1;
        }
      }
      );
    }
  }
}





class Address{
  int id;
  String houseNumber;
  String apartmentName;
  String streetDetails;
  String landMark;
  String locality;
  String areaDetails;
  String city;
  String pinCode;
  String addressType;
  String addressName;
  String mobileNumber;

  Address({
    this.id,
    this.houseNumber,
    this.apartmentName,
    this.streetDetails,
    this.landMark,
    this.locality,
    this.areaDetails,
    this.city,
    this.pinCode,
    this.addressType,
    this.addressName,
    this.mobileNumber
});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id : json["address_id"],
      houseNumber:  json["house_number"],
      apartmentName: json["apartment"],
      streetDetails: json["street"],
      areaDetails: json["area"],
      city: json["city"],
      pinCode: json["pincode"].toString(),
      addressType: json["address_type"]
    );
  }
}

class Order{
  String orderId;
  String name;
  double amount;
  String orderTime;
  var orderItemsData;
  List<orderItems> orderItemsList;


  Order({
    this.name,
    this.amount,
    this.orderId,
    this.orderTime,
    this.orderItemsData
}){
    createOrderItems();
  }


  createOrderItems(){
    if(orderItemsData != null){
      var rest = orderItemsData as List;

      if(rest.length > 0){
        //selectedAddress = addressDat;
        orderItemsList = rest.map<orderItems>((json) => orderItems.fromJson(json)).toList();
      }
    }
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      name : json["name"],
      orderId: json["order_id"],
      amount: json["bill_amount"],
      orderTime: json["order_time"],
      orderItemsData: json['items'],
    );
  }

}

class orderItems{
  String upcCode;
  int qty;


  orderItems({
    this.upcCode,
    this.qty
});


  factory orderItems.fromJson(Map<String, dynamic> json) {
    return orderItems(
     upcCode: json['item_upc'],
      qty: json['quantity'],
    );
  }
}