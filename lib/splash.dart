import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:contact_book/registerpage.dart';
import 'package:contact_book/viewpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkconnection();
  }

  checkconnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile)
    {
      // I am connected to a mobile network.
      setState(() {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return viewpage();
          },
        ));
      });
    }
    else if (connectivityResult == ConnectivityResult.wifi)
    {
      // I am connected to a wifi network.
      setState(() {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return viewpage();
          },
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
