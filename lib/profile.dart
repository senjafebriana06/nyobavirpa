import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyobavirpa/models/profile_model.dart';
import 'package:nyobavirpa/profileForm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SharedPreferences? prefs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    print("init");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<ProfileModel>(
          future: _getProfile(),
          builder: (context, profileSnap) {
            if (profileSnap.data?.nama == null ||
                profileSnap.data?.jenisKelamin == null ||
                profileSnap.data?.umur == null) {
              return Container(
                child: Center(child: Text("Loading")),
              );
            }
            if (profileSnap.data?.nama == "" ||
                profileSnap.data?.jenisKelamin == "" ||
                profileSnap.data?.umur == 0) {
              return Container(
                padding: const EdgeInsets.all(18.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Profil Belum Diisi"),
                    const SizedBox(
                      height: 18.0,
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        width: 100.0,
                        color: Colors.orange,
                        child: Center(child: Text("Isi profile")),
                      ),
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ProfileForm()))
                            .then;
                        ;
                      },
                    )
                  ],
                ),
              );
            }
            return Container(
              width: double.infinity,
              child: Column(
                children: [
                  Text((profileSnap.data?.nama)!),
                  Text((profileSnap.data?.jenisKelamin)! == "L"
                      ? "Laki-laki"
                      : "Perempuan"),
                  Text((profileSnap.data?.umur)!.toString()),
                  InkWell(
                    child: Container(
                      child: Center(
                          child: Text(
                        "Ubah",
                        style: TextStyle(color: Colors.white),
                      )),
                      color: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      width: 100.0,
                    ),
                    onTap: () async {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const ProfileForm()));
                      prefs = await SharedPreferences.getInstance();
                      String? id = prefs?.getString("id");
                      print("tapp");
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<ProfileModel> _getProfile() async {
    prefs = await SharedPreferences.getInstance();
    String? id = prefs?.getString("id");

    ProfileModel profileModel =
        ProfileModel(jenisKelamin: "", nama: "", umur: 0);

    await firestore.collection("users").doc(id).get().then((result) {
      if (result.data()!['name'] != null &&
          result.data()!['gender'] != null &&
          result.data()!['age'] != null) {
        profileModel = ProfileModel(
            nama: result.data()!['name'],
            umur: result.data()!['age'],
            jenisKelamin: result.data()!['gender']);
      }
    });
    return profileModel;
  }
}
