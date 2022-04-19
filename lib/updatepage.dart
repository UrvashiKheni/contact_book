import 'dart:convert';
import 'dart:io';

import 'package:contact_book/viewpage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class updatepage extends StatefulWidget {
  Map<dynamic, dynamic> m;

  updatepage(this.m);

  @override
  _updatepageState createState() => _updatepageState();
}

class _updatepageState extends State<updatepage> {
  final ImagePicker _picker = ImagePicker();
  String path = "";

  TextEditingController tname = TextEditingController();
  TextEditingController tcontact = TextEditingController();

  bool nameerror = false;
  bool contacterror = false;
  String namemessage = "";
  String contactmessage = "";

  String imagename = "";
  String id = "";
  String imageurl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tname.text = widget.m['name'];
    tcontact.text = widget.m['contact'];
    imagename = widget.m['imagename'];
    id = widget.m['id'];
    imageurl = "https://urvitechno.000webhostapp.com/APICalling/${imagename}";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              "update detail",
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
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: path.isEmpty
                      ? ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(52), // Image radius
                            child: Image.network(
                              imageurl,
                              errorBuilder: (context, error, stackTrace) {
                                return ClipOval(
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(52), // Image radius
                                    child: Image.asset("images/1.jpg"),
                                  ),
                                );
                              },
                              height: 100,
                              width: 100,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(48), // Image radius
                            child: Image.file(File(path)),
                          ),
                        )),
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
                  String newname = tname.text;
                  String newcontact = tcontact.text;

                  String newimagestr = "";
                  if (path.isNotEmpty) {
                    File file = File(path);
                    List<int> list = file.readAsBytesSync();
                    newimagestr = base64Encode(list);
                    print(newimagestr);
                  }

                  if (newname.isEmpty) {
                    setState(() {
                      namemessage = "enter your name";
                      nameerror = true;
                    });
                  }
                  if (newcontact.isEmpty) {
                    setState(() {
                      contactmessage = "enter your phone number";
                      contacterror = true;
                    });
                  } else {
                    Map m = {
                      'id': id,
                      'newname': newname,
                      'newcontact': newcontact,
                      'newimagestr': newimagestr,
                      'imagename': imagename,
                    };

                    //ToDO update Data  API
                    var url = Uri.parse(
                        'https://urvitechno.000webhostapp.com/APICalling/updateprofile.php');
                    var response = await http.post(url, body: m);

                    print('Response status: ${response.statusCode}'); // 200
                    print('Response body: ${response.body}');

                    Map map = jsonDecode(response.body);

                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return viewpage();
                      },
                    ));
                  }
                },
                text: "update",
              ),
            ],
          ),
        ),
        onWillPop: goback);
  }

  Future<bool> goback() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return viewpage();
      },
    ));
    return Future.value();
  }
}
