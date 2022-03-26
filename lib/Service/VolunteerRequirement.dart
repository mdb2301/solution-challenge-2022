import 'package:location/location.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VolunteerRequirement{
  String ?reqId,ngoId,title,description;
  LocationData location;
  DateTime start,end,postedOn;
  List<Volunteer> volunteers;
  int donationPoints;

  VolunteerRequirement({
    this.reqId,
    required this.ngoId,
    required this.title,
    required this.description,
    required this.location,
    required this.start,
    required this.end,
    required this.postedOn,
    required this.volunteers,
    required this.donationPoints
  });

  factory VolunteerRequirement.fromJson(json){
    List<Volunteer> m = [];
    json['volunteers'].forEach((el){
      m.add(Volunteer.fromJson(el));
    });
    return VolunteerRequirement(
      reqId:json['reqId']??json.id,
      ngoId:json['ngoId'], 
      title:json['title'], 
      description:json['description'], 
      location:LocationData.fromMap(json['location']), 
      start:DateTime.fromMillisecondsSinceEpoch(json['start']), 
      end:DateTime.fromMillisecondsSinceEpoch(json['end']), 
      postedOn:DateTime.fromMillisecondsSinceEpoch(json['postedOn']), 
      volunteers:m, 
      donationPoints:json['donationPoints']
    );
  }

  String getStartDate()=>_parseTimestampEntity(start.day)+"/"+_parseTimestampEntity(start.month)+"/"+_parseTimestampEntity(start.year);
  String getEndDate()=>_parseTimestampEntity(end.day)+"/"+_parseTimestampEntity(end.month)+"/"+_parseTimestampEntity(end.year);
  String getPostedDate()=>_parseTimestampEntity(postedOn.day)+"/"+_parseTimestampEntity(postedOn.month)+"/"+_parseTimestampEntity(postedOn.year);

  static _parseTimestampEntity(int? value){
    if(value!>9)return value.toString();
    return "0"+value.toString();
  }

  toJson()=>{
    'reqId':reqId,
    'ngoId':ngoId,
    'title':title,
    'description':description,
    'location':{'latitude':location.latitude,'longitude':location.longitude},
    'start':start.millisecondsSinceEpoch,
    'end':end.millisecondsSinceEpoch,
    'postedOn':postedOn.millisecondsSinceEpoch,
    'volunteers':volunteers.map((e) => {"uid":e.uid,"hasRedeemed":e.hasRedeemed}).toList(),
    'donationPoints':donationPoints,
  };

  getQR()=>QrImage(
    data:reqId.toString()+"_"+donationPoints.toString(),
    size:250
  );
  //TODO: ADD ENCRYPTION TO DATA
  //TODO: CHANGE STYLES

}

class Volunteer{
  String uid;bool hasRedeemed;
  Volunteer({required this.uid,required this.hasRedeemed});
  factory Volunteer.fromJson(json)=>Volunteer(uid:json["uid"], hasRedeemed:json["hasRedeemed"]);
  toJson()=>{"uid":uid,"hasRedeemed":hasRedeemed};
}