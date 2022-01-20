import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vertitect_app/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:vertitect_app/screens/details_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController dateinput = TextEditingController();

  late UserModel _userModel;
  bool hasLoaded = false;
  String date = "19-01-2022";

  Future<UserModel> _getUserData() async {
    final queryParameters = {
      'p': 'date-attendance',
    };

    var response = await http.post(
        Uri.https('hrm.abybabyevents.in', '/api/index.php', queryParameters),
        body: {"date": date});

    var data = jsonDecode(response.body.toString());
    print(data);

    if (response.statusCode == 200) {
      _userModel = UserModel.fromJson(data);
      setState(() {
        hasLoaded  =true;
      });
      return _userModel;
    } else {
      print(response.statusCode);
      _userModel = UserModel();
      return _userModel;
    }
  }




  @override
  void initState() {
    super.initState();
    dateinput.text = "15/01/2021";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF09b387),
          title: const Center(
            child: Text('Attendance Report'),
          ),
        ),
        body: getMainBody()
    );
  }

  Column getMainBody() {
    return Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              readOnly: true,
              controller: dateinput,

              onTap: ()async {
                DateTime? pickedDate = await showDatePicker(
                    context: context, initialDate: DateTime.now(),
                    firstDate: DateTime(2021), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2023)
                );

                if(pickedDate != null ){
                  print(pickedDate);
                  String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                  print(formattedDate);
                  setState(() {
                    dateinput.text = formattedDate;
                  });
                }else{
                  print("Date is not selected");
                }
              },

              decoration: InputDecoration(
                hintText: date,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/calendar.png',height: 10.0,width: 10.0,),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                labelText: 'Select Date',
                labelStyle:
                    const TextStyle(fontSize: 22.0, color: Colors.green),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: createFutureBuilder(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {  },
                  style:  ElevatedButton.styleFrom(
                    primary:  Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    (() {
                      if (hasLoaded) {
                        return 'Total : ${_userModel.total}';
                      }

                      return "N/A";
                    })(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {  },
                  style:  ElevatedButton.styleFrom(
                    primary:  Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    (() {
                      if (hasLoaded) {
                        return 'Present : ${_userModel.present}';
                      }
                      return "N/A";
                    })(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {  },
                  style:  ElevatedButton.styleFrom(
                    primary:  Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    (() {
                      if (hasLoaded) {
                        return 'Absent : ${_userModel.absent}';
                      }

                      return "N/A";
                    })(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12.0),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 40.0,)
        ],
      );
  }

  FutureBuilder<UserModel> createFutureBuilder() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<UserModel> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Text('Loading data.....'));
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Table(
                border: TableBorder.all(color: Colors.black),
                children: [
                  TableRow(
                      children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        snapshot.data!.data![index].name.toString() ,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        (() {
                          if (snapshot.data!.data![index].det!.isNotEmpty) {
                            return snapshot.data!.data![index].det![0].clockIn
                                .toString();
                          }

                          return "N/A";
                        })(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        (() {
                          if (snapshot.data!.data![index].det!.isNotEmpty) {
                            return snapshot.data!.data![index].det![0].clockOut
                                .toString();
                          }

                          return "N/A";
                        })(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(data: snapshot.data!.data![index])));
                        },
                        style:  ElevatedButton.styleFrom(
                          primary: snapshot.data!.data![index].status == "Present"? Colors.green : Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          (() {
                            if (snapshot.data!.data![index].status!.isNotEmpty) {
                              return snapshot.data!.data![index].status
                                  .toString();
                            }

                            return "N/A";
                          })(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.0),
                        ),
                      ),
                    )
                  ])
                ],
              );
            },
            itemCount: _userModel.data!.length,
          );
        }
      },
      future: _getUserData(),
    );
  }


}
