
import 'dart:convert';

class Attended {
  int? userid;
  String? TypeTime;
  String? Time;
  int? Longitude;
  int? Latitude;
  int? KantorId;

  Attended ({
    this.KantorId, this.Latitude, this.Longitude, this.Time, this.TypeTime, this.userid
  });

  factory Attended.fromJson(Map<String,dynamic> json){
    return Attended(
      userid: json['userid'] ?? 0,
      Time: json['time'] ?? '',
      Latitude: json['latitude'] ?? '',
      Longitude: json['longitude'] ?? '',
      KantorId: json['kantorid'] ?? 0,
      TypeTime: json['typetime'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'time': Time,
      'latitude': Latitude,
      'longitude': Longitude,
      'kantorid': KantorId,
      'typetime': TypeTime
    };
  }

}