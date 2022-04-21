import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentEntity {
  String? docId;
  int? age;
  Timestamp? bookingDate;
  Timestamp? bookingTime;
  String? firstName;
  String? lastName;
  String? gender;
  String? email;
  double? latitude;
  double? longitude;
  String? hospitalName;
  String? hospitalAddress;
  String? hospitalImage;
  String? hospitalStatus;
  String? userId;
  bool isAccept = false;
  bool isCancelled = false;

  AppointmentEntity({
    this.docId,
    this.age,
    this.bookingDate,
    this.bookingTime,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.latitude,
    this.longitude,
    this.hospitalName,
    this.hospitalAddress,
    this.hospitalImage,
    this.hospitalStatus,
    this.userId,
    this.isAccept = false,
    this.isCancelled = false,
  });
}

