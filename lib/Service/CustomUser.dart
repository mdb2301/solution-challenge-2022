import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class CustomUser{

  static var tablename = "users";

  final String? uid,displayName,email;
  String? phone;
  final int donationPoints;

  CustomUser({
    required this.uid,
    required this.displayName,
    required this.email,
    this.phone,
    this.donationPoints = 0
  });

  factory CustomUser.fromJson(json)
    => CustomUser(
      uid:json["uid"]??json.id, 
      displayName:json["displayName"], 
      email:json["email"], 
      phone:json["phone"],
      donationPoints:json["donationPoints"],
    );

  static fromFirebase(String uid) async {
    final res = await FirebaseFirestore.instanceFor(app:Firebase.app()).collection(tablename).doc(uid).get();
    if(res.exists){
      return CustomUser.fromJson(res.data());
    }
    return null;
  }

  toJson()=>{
    "uid":uid,
    "displayName":displayName,
    "email":email,
    "phone":phone,
    "donationPoints":donationPoints,
  };
}