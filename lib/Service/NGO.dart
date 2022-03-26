import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class NGO{
  String ?ngoId,email,name,registrationNumber,address,accountNo,ifscCode,bankName,branchName;

  static String tablename = "ngoTable";

  NGO({
    this.ngoId,
    required this.name,
    required this.email,
    required this.registrationNumber,
    required this.address,
    this.accountNo,
    this.bankName,
    this.branchName,
    this.ifscCode
  });

  factory NGO.fromJson(json)=>NGO(
    ngoId:json['ngoId']??json.id,
    name:json['name'],
    email:json['emaild'],
    registrationNumber:json['registrationNumber'],
    address:json['address'],
    accountNo:json['accountNo'],
    bankName:json['bankName'],
    branchName:json['branchName'],
    ifscCode:json['ifscCode'],
  );

  static fromFirebase(String ngoId) async {
    final res = await FirebaseFirestore.instanceFor(app:Firebase.app()).collection(tablename).doc(ngoId).get();
    if(res.exists){
      return NGO.fromJson(res.data());
    }
    return null;
  }

  toJson()=>{
    'ngoId':ngoId,
    'name':name,
    'email':email,
    'registrationNumber':registrationNumber,
    'address':address,
    'accountNo':accountNo,
    'bankName':bankName,
    'branchName':branchName,
    'ifscCode':ifscCode
  };

  setBankDetails(String branch,String acno,String bankname,String ifsc){
    bankName = name;
    accountNo = acno;
    branchName = branch;
    ifscCode = ifsc;
  }
}

class NGORequirement{
  String? reqId,ngoId,title,description;
  int requestedAmount,collectedAmount;
  DateTime deadline,postedOn;
  List<Donor> donors;

  NGORequirement({
    this.reqId,
    required this.ngoId,
    required this.title,
    required this.description,
    required this.requestedAmount,
    this.collectedAmount = 0,
    required this.deadline,
    required this.postedOn,
    this.donors = const []
  });

  factory NGORequirement.fromJson(json){
    List<Donor> m = [];
    json['donors'].forEach((el){
      m.add(Donor.fromJson(el));
    });
    return NGORequirement(
      reqId:json['reqId']??json.id,
      ngoId:json['ngoId'], 
      title:json['title'], 
      description:json['description'], 
      requestedAmount:json['requestedAmount'], 
      collectedAmount:json['collectedAmount'], 
      deadline:DateTime.fromMillisecondsSinceEpoch(json['deadline']), 
      postedOn:DateTime.fromMillisecondsSinceEpoch(json['postedOn']),
      donors:m
    );
  }

  toJson()=>{
    'reqId':reqId,
    'ngoId':ngoId,
    'title':title,
    'description':description,
    'requestedAmount':requestedAmount,
    'collectedAmount':collectedAmount,
    'deadline':deadline.millisecondsSinceEpoch,
    'postedOn':postedOn.millisecondsSinceEpoch,
    'donors':donors.map((e) => {"uid":e.uid,"transactionId":e.transactionId}).toList(),
  };
}

class Donor{
  String uid,transactionId;
  Donor({required this.uid,required this.transactionId});
  factory Donor.fromJson(json)=>Donor(uid:json['uid'],transactionId:json['transactionId']);
  toJson()=>{'uid':uid,'transactionId':transactionId};
}

class Transaction{
  String? txnId,uid,ngoId,requestId;
  int amount;
  DateTime timestamp;

  Transaction({
    this.txnId,
    required this.uid,
    required this.ngoId,
    this.requestId,
    required this.amount,
    required this.timestamp
  });

  factory Transaction.fromJson(json) => Transaction(
    txnId:json['txnId']??json.id,
    uid:json['uid'], 
    ngoId:json['ngoId'], 
    amount:json['amount'], 
    requestId:json['requestId'],
    timestamp:DateTime.fromMillisecondsSinceEpoch(json['timestamp'])
  );

  toJson()=>{
    "txnId":txnId,
    "uid":uid,
    "ngoId":ngoId,
    "amount":amount,
    "requestId":requestId,
    "timestamp":timestamp.millisecondsSinceEpoch,
  };
}