import 'dart:convert';

import 'package:contact_book/registerpage.dart';
import 'package:contact_book/updatepage.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:http/http.dart' as http;

class viewpage extends StatefulWidget {
  const viewpage({Key? key}) : super(key: key);

  @override
  _viewpageState createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {
  List list = [];

  bool ready = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PaintingBinding.instance!.imageCache!.clear();
    getAllData();
  }

  getAllData() async {
    var url =
        Uri.parse('https://urvitechno.000webhostapp.com/APICalling/view.php');
    var response = await http.get(url);

    print('Response status: ${response.statusCode}'); // 200
    print('Response body: ${response.body}');

    Map m = jsonDecode(response.body);

    int connection = m['connection'];

    if (connection == 1) {
      int result = m['result'];

      if (result == 1) {
        list = m['userdata'];
        ready = true;
        print(list);
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("details"),
      ),
      body: ready
          ? ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Map m = list[index];
                String imageurl =
                    "https://urvitechno.000webhostapp.com/APICalling/${m['imagename']}";
                return ListTile(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Update or Delete"),
                            content: Text("Please select your choice..."),
                            actions: [
                              TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return updatepage(m);
                                      },
                                    ));
                                  },
                                  icon: Icon(Icons.edit),
                                  label: Text("Update")),
                              TextButton.icon(
                                  onPressed: () async {
                                    String id = m['id'];
                                    String imagename = m['imagename'];

                                    var url = Uri.parse(
                                        'https://urvitechno.000webhostapp.com/APICalling/delete.php?id=$id&imagename=$imagename');
                                    var response = await http.get(url);

                                    print(
                                        'Response status: ${response.statusCode}'); // 200
                                    print('Response body: ${response.body}');

                                    Navigator.pop(context);

                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return viewpage();
                                      },
                                    ));
                                  },
                                  icon: Icon(Icons.delete),
                                  label: Text("Delete")),
                            ],
                          );
                        },
                      );
                    },
                    title: Text(m['name']),
                    subtitle: Text(m['contact']),
                    leading: GFImageOverlay(
                      height: 50,
                      width: 50,
                      shape: BoxShape.circle,
                      image: NetworkImage(imageurl),
                      boxFit: BoxFit.cover,
                    ));
              },
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return registerpage();
            },
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
