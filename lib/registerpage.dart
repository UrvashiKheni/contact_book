import 'dart:convert';
import 'dart:io';

import 'package:contact_book/viewpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class registerpage extends StatefulWidget {
  const registerpage({Key? key}) : super(key: key);

  @override
  _registerpageState createState() => _registerpageState();
}

class _registerpageState extends State<registerpage> {
  TextEditingController tname = TextEditingController();
  TextEditingController tcontact = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String path = "";

  bool nameerror = false;
  bool contacterror = false;
  String namemessage = "";
  String contactmessage = "";


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "fill the detail",
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text("Select Image"),
                    children: [
                      ListTile(
                        title: Text("Camera"),
                        leading: Icon(Icons.camera),
                        onTap: () async {
                          Navigator.pop(context);
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.camera);

                          path = image!.path;

                          setState(() {});
                        },
                      ),
                      ListTile(
                        title: Text("Gallery"),
                        leading: Icon(Icons.photo),
                        onTap: () async {
                          Navigator.pop(context);
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          path = image!.path;
                          setState(() {});
                        },
                      )
                    ],
                  );
                },
              );
            },
            child: path.isNotEmpty ? ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(48), // Image radius
                child: Image.file(File(path)),
              ),
            )
             : ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(48), // Image radius
                child: Image.asset("images/1.jpg"),
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  nameerror = false;
                });
              },
              controller: tname,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.person),
                errorText: nameerror ? namemessage : null,
                hintText: 'Enter your name',
                labelText: 'Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  contacterror = false;
                });
              },
              controller: tcontact,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.phone),
                errorText: contacterror ? contactmessage : null,
                hintText: 'Enter a phone number',
                labelText: 'phone',
              ),
            ),
          ),
          GFButton(
            onPressed: () async {
              String name = tname.text;
              String contact = tcontact.text;

              if (name.isEmpty)
              {
                setState(() {
                  namemessage = "enter your name";
                  nameerror = true;
                });
              }
              if (contact.isEmpty)
              {
                setState(() {
                  contactmessage = "enter your phone number";
                  contacterror = true;
                });
              }
              else
              {
                File file = File(path);
                List<int> list = file.readAsBytesSync();
                String imagestr = base64Encode(list);
                print(imagestr);

                Map m = {
                  'name': name,
                  'contact': contact,
                  'imagestr': imagestr,
                };

                //ToDO Insert Data  API

                var url = Uri.parse(
                    'https://urvitechno.000webhostapp.com/APICalling/insert.php');
                var response = await http.post(url, body: m);

                print('Response status: ${response.statusCode}'); // 200
                print('Response body: ${response.body}');

                Map map = jsonDecode(response.body);

                int connection = map['connection'];

                if (connection == 1)
                {
                  int result = map['result'];

                  if (result == 1)
                  {

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return viewpage();
                    },
                    ));
                  }
                  else
                  {
                    print("Data Not Inserted");
                    Fluttertoast.showToast(
                        msg: "Data Not Inserted..!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                }
                else
                {
                  print("Server error...");
                  Fluttertoast.showToast(
                      msg: "server error...",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              }
            },
            text: "save",
          ),
        ],
      ),
    ), onWillPop: goback);
  }
  Future<bool> goback()
  {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return viewpage();
    },
    ));
    return Future.value();
  }
}
