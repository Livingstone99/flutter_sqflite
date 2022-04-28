import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/dbInstance.dart';
import 'package:flutter_application_1/readDb.dart';
import 'package:flutter_application_1/userModel.dart';
import 'package:flutter_application_1/userProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/Provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isloading = false;
  bool _fetch = false;
  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _fetch
                  ? const Text("fetched successfully")
                  : const Text('click the button to get the user data'),
              const SizedBox(height: 20),
              _isloading ? const CircularProgressIndicator() : Container(),
              const SizedBox(height: 20),
              _fetch
                  ? Text("first name : ${userProv.user?.firstname}")
                  : Container(),
              const SizedBox(height: 20),
              _fetch
                  ? Text("last name : ${userProv.user?.lastname}")
                  : Container(),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                      onPressed: clearDb,
                      tooltip: 'clear fetch data',
                      heroTag: null,
                      child: const Icon(Icons.delete),
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        var userProv =
                            Provider.of<UserProvider>(context, listen: false);
                        if (userProv.user != null) {
                          await DatabaseHelper.instance.insertUser(UserModel(
                            firstname: userProv.user!.firstname,
                            lastname: userProv.user!.lastname,
                            loggedIn: userProv.user!.loggedIn,
                          ));
                        }
                      },
                      tooltip: 'persist data',
                      heroTag: null,
                      child: const Icon(Icons.save),
                    ),
                    FloatingActionButton(
                      onPressed: getdata,
                      tooltip: 'fetch data',
                      heroTag: null,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ReadDb())),
                tooltip: 'check database',
                heroTag: null,
                child: const Icon(Icons.read_more),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> getdata() async {
    setState(() {
      _isloading = true;
    });
    Uri url =
        Uri.parse("https://secured-taxi.herokuapp.com/driver/onebycode/aaaa");
    var response = await http.get(url);
    print(response.body);
    final userProv = Provider.of<UserProvider>(context, listen: false);
    var info = json.decode(response.body);
    UserModel userMod = UserModel.fromJson({...info["driver"], "logged": true});
    userProv.setUser = userMod;
    setState(() {
      _fetch = true;
      _isloading = false;
    });
  }

  Future<void> clearDb() async {
    setState(() {
      _isloading = true;
    });
    var userProv = Provider.of<UserProvider>(context, listen: false);
    userProv.setUser = null;
    setState(() {
      _isloading = false;
      _fetch = false;
    });
  }
}
