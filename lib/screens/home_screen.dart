import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vertitect_app/model/user_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserModel _userModel;

  Future<UserModel> _getUserData() async {

    final queryParameters = {
      'p': 'date-attendance',

    };
    final uri = Uri.http('hrm.abybabyevents.in', '/api/index.php', queryParameters);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    print(response.statusCode);
    var data;
    if(response.body.isNotEmpty) {
     data =  json.decode(response.body);
    }else{
      print('empty body');
    }
        // var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      UserModel userModel = UserModel.fromJson(data);
      return userModel;
    } else {
      print(response.statusCode);
      UserModel userModel = UserModel();
      return userModel;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_){
      _getUserData();
    });
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
      body: Text("Loading"),
      // body: FutureBuilder(
      //   builder: (context, AsyncSnapshot<UserModel> snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(child: Text('Loading data.....'));
      //     } else {
      //       return const Center(
      //         child: Text('Loaded'),
      //       );
      //     }
      //   },
      //   future: getUserData(),
      // ),
    );
  }
}
