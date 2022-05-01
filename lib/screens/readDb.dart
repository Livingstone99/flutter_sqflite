import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/dbInstance.dart';
import 'package:flutter_application_1/models/userModel.dart';
import 'package:flutter_application_1/providers/userProvider.dart';
import 'package:provider/provider.dart';

class ReadDb extends StatefulWidget {
  const ReadDb({Key? key}) : super(key: key);

  @override
  State<ReadDb> createState() => _ReadDbState();
}

class _ReadDbState extends State<ReadDb> {
  UserModel? _user;
  @override
  void initState() {
    // TODO: implement initState

    var user = DatabaseHelper.instance.getUser().then((users) {
      setState(() {
        _user = users;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Read from SqliteDb"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Persisted data in Database'),
              const SizedBox(height: 20),
              Text('first name : ${_user?.firstname ?? "no data"}'),
              const SizedBox(height: 20),
              Text('last name : ${_user?.lastname ?? "no data"}'),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  child: Icon(Icons.refresh),
                  onPressed: () async {
                    var user = await DatabaseHelper.instance.removeUser();
                    setState(() {
                      _user = null;
                    });
                  },
                  tooltip: 'clear db',
                  heroTag: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> clearDb() async {
    var userProv = Provider.of<UserProvider>(context, listen: false);
    userProv.setUser = null;
  }
}
