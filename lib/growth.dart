import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:nyobavirpa/models/gender_enum.dart';
import 'package:nyobavirpa/models/growth_list_model.dart';
import 'package:nyobavirpa/models/growth_model.dart';
import 'package:nyobavirpa/models/weight_status_enum.dart';
import 'package:nyobavirpa/service/weight_status_to_string_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/height_status_enum.dart';
import 'service/height_status_to_string_service.dart';

class Growth extends StatefulWidget {
  const Growth({Key? key}) : super(key: key);

  @override
  State<Growth> createState() => _GrowthState();
}

class _GrowthState extends State<Growth> {
  SharedPreferences? prefs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final f = DateFormat('yyyy-MM-dd hh:mm');
  List growthList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<GrowthListModel>(
            future: _getGrowthList(),
            builder: (context, profileSnap) {
              if (profileSnap.data?.growthList == null) {
                return Container(
                  child: Center(child: Text("Loading")),
                );
              }
              if (profileSnap.data!.growthList.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(18.0),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Belum ada riwayat pengukuran"),
                      const SizedBox(
                        height: 18.0,
                      ),
                    ],
                  ),
                );
              }
              return Container(
                child: ListView(children: [
                  for (final growth in profileSnap.data!.growthList)
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(118, 68, 137, 255)),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.all(8.0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text("Nama: "),
                            Text(growth.name)
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text("Umur: "),
                            Text(growth.age.toString())
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text("Jenis Kelamin: "),
                            Text(growth.gender == Gender.L
                                ? "Laki-laki"
                                : "Perempuan")
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text("Tanggal: "),
                            Text(f.format(growth.date.toDate())),
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text("Status Berat Badan: "),
                            Text(weightStatusToString(growth.weightStatus))
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text("Status Tinggi Badan: "),
                            Text(heightStatusToString(growth.heightStatus))
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text("Berat Badan: "),
                            Text(growth.weight.toStringAsFixed(2) + " Kg")
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text("Tinggi Badan: "),
                            Text(growth.height.toStringAsFixed(2) + " Cm")
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                        ],
                      ),
                    )
                ]),
              );
            }),
      ),
    );
  }

  Future<GrowthListModel> _getGrowthList() async {
    prefs = await SharedPreferences.getInstance();
    String? id = prefs?.getString("id");

    List<GrowthModel> growthList = [];

    late String name;
    late int age;
    late Gender gender;
    late double weight;
    late double height;

    await firestore.collection("users").doc(id).get().then((result) {
      if (result.data()!['name'] != null &&
          result.data()!['gender'] != null &&
          result.data()!['age'] != null) {
        name = result.data()!['name'];
        age = result.data()!['age'];
        gender = result.data()!['gender'] == "L" ? Gender.L : Gender.P;
      }
    });

    await firestore.collection("users").doc(id).get().then((result) {
      if (result.data()!['growth'] != null) {
        WeightStatus weightStatus;
        HeightStatus heightStatus;

        for (final growthItem in result.data()!['growth']) {
          switch (growthItem['weightStatus']) {
            case "NORMAL":
              weightStatus = WeightStatus.normal;
              break;
            default:
              weightStatus = WeightStatus.overweight;
          }
          switch (growthItem['heightStatus']) {
            case "NORMAL":
              heightStatus = HeightStatus.normal;
              break;
            default:
              heightStatus = HeightStatus.tinggi;
          }
          GrowthModel growthModel = GrowthModel(
              name: growthItem['name'],
              gender: growthItem['gender'] == "L" ? Gender.L : Gender.P,
              date: growthItem['time'],
              weightStatus: weightStatus,
              heightStatus: heightStatus,
              age: growthItem['age'],
              height: growthItem['height'],
              weight: growthItem['weight']);

          growthList.add(growthModel);
        }
      }
    });
    GrowthListModel growthListModel = GrowthListModel(growthList: growthList);
    return growthListModel;
  }
}
