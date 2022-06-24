import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyobavirpa/models/gender_enum.dart';
import 'package:nyobavirpa/models/weight_status_enum.dart';

class GrowthModel {
  String name;
  Gender gender;
  int age;
  Timestamp date;
  Status status;
  double weight;
  double height;

  GrowthModel(
      {required this.name,
      required this.gender,
      required this.age,
      required this.date,
      required this.status,
      required this.weight,
      required this.height});
}
