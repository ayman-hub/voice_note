import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:voice_note/voice/domain/use_cases/authinticate.dart';
import 'package:voice_note/injection.dart';
import 'package:voice_note/voice/domain/use_cases/constant_data.dart';
import 'package:voice_note/voice/domain/entities/data_entities.dart';
import 'package:voice_note/voice/domain/entities/login_data.dart';
import 'package:voice_note/voice/domain/use_cases/case.dart';
import 'package:voice_note/voice/presentation/pages/login/login_page.dart';
import 'package:voice_note/voice/presentation/widgets/audio/audio.dart';
import 'package:voice_note/voice/presentation/widgets/loading_widget.dart';
import 'package:voice_note/toast_utils.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  bool showProgress = false;

  final formKey = GlobalKey<FormState>();

  int selectedIndex = 200000000000;

 late  Future futureData;

  String note = "";

  void getData() {
    setState(() {
      futureData = sl<Cases>().getData();
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  showProgress = true;
                });
                sl<Cases>().setLoginData(LoginData(password: "", email: ""));
                signOutGoogle();
                logOut();
                setState(() {
                  showProgress = false;
                });
                Get.off(() => LoginPage(), transition: Transition.fadeIn);
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                  future: futureData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.hasError){
                      print('snapshotError::::: ${snapshot.error}');
                      return errorContainer(context,(){
                        getData();
                      });
                    }
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                        return loadingContainer();
                        break;
                      case ConnectionState.active:
                        if (snapshot.data != null) {
                          if(snapshot.data is List<DataEntities>){
                            return bodyWidget(snapshot.data);
                          }
                        }
                        return errorContainer(context,(){
                          getData();
                        });
                        break;
                      case ConnectionState.done:
                        if (snapshot.data != null) {
                          if(snapshot.data is List<DataEntities>){
                            return bodyWidget(snapshot.data);
                          }
                        }
                        return errorContainer(context,(){
                          getData();
                        });
                        break;
                    }
                    return errorContainer(context, (){
                      getData();
                    });
                  }),
            ),
          ),
          showProgress ? loadingContainer() : Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: bottomSheetMethod
      ),
    );
  }

  Widget bodyWidget(List<DataEntities> data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(5),
             decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(5),
                                     color: Colors.white,
                                     boxShadow: [
                                       BoxShadow(
                                         color: Colors.grey,
                                         blurRadius: 2.0,
                                         spreadRadius: 0.0,
                                         offset: Offset(
                                             2.0, 2.0), // shadow direction: bottom right
                                       )
                                     ],
                                   ),
            child: Slidable(
              key: Key(data[index].date.toString()),
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              direction: Axis.horizontal,
              secondaryActions: [
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () async {
                    setState(() {
                      showProgress = true;
                    });
                    await sl<Cases>().removeFile(
                        data[index].date.toString());
                    var response = await sl<Cases>()
                        .deleteData(data[index]);
                    setState(() {
                      showProgress = false;
                    });
                    if (response == true) {
                      setState(() {
                        data.removeAt(index);
                      });
                    } else {
                      showToast("error: $response");
                    }
                  },
                ),
              ],
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10,bottom: 2,top: 10),
                    child: Text("Date: ${DateFormat("dd /MM/yyyy hh:mm a").format(data[index].date)}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ),
                  AudioWidget(
                    link: data[index].link,
                    type: TypeAudio.link,
                    index: index,
                    selectedIndex: (selected) {
                      setState(() {
                        this.selectedIndex = selected;
                      });
                    },
                    selected: selectedIndex,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: Text('Note:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10,bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text('${data[index].note}',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),

                  ),
                ],
              ),
            ),
          );
        });
  }
  void bottomSheetMethod() async {
    bool play = false;
    String path = "";
    bool progress = false;
    DateTime time = DateTime.now();
    bool refresh = false;
     refresh = await showModalBottomSheet(
       isScrollControlled: true,
        enableDrag: true,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10))),
        context: context,
        builder: (bottomSheetContext) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: play
                      ? Container(
                    alignment: Alignment.center,
                    child: Lottie.asset("images/voice_bar.json"),
                  )
                      : path.isEmpty
                      ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Start Recording',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                      : SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.75,
                          child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                          Row(
                            children: [
                              Expanded(
                                child: AudioWidget(
                                  audio: path,
                                  type: TypeAudio.audio,
                                  index: 0,
                                  selectedIndex: (selected) {},
                                  selected: 0,
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    try {
                                      File file = File(path);
                                      file.deleteSync();
                                      setState(() {
                                        path = "";
                                      });
                                    } catch (e) {
                                      print(
                                          'deleteFileError::: $e');
                                    }
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                      Flexible(child: SizedBox(height: 10,)),
                    TextField(
                          maxLines: 4,
                          onChanged: (value) {
                            note = value;
                          },
                          style: TextStyle(fontSize: 15.0),
                          decoration: InputDecoration(
                              hintText: "write notes",
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              labelStyle: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                      Flexible(child: SizedBox(height: 10,)),
                          progress
                              ? Container(
                            height: 48,
                            child: loadingContainer(),
                          )
                              : TextButton(
                              onPressed: () async {
                                setState(() {
                                  progress = true;
                                });
                                var link = await sl<Cases>()
                                    .uploadFile(
                                    Uint8List.fromList(File(
                                        path)
                                        .readAsBytesSync()),
                                    time.toString());
                                DataEntities data =
                                DataEntities(
                                    date: time, link: link,note: note);
                                var response = await sl<Cases>()
                                    .insertData(data);
                                setState(() {
                                  progress = false;
                                });
                                if (response == true) {
                                  Get.back(result: true);
                                } else {
                                  showToast(
                                      "error has been happen");
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 48,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(
                                        5),
                                    color: staticColor),
                                width: 150,
                                child: Text(
                                  'INSERT',
                                  style: TextStyle(
                                      color: Colors.white),
                                ),
                              ))
                    ],
                  ),
                        ),
                      ),
                ),
                floatingActionButton: path.isNotEmpty && !play?Container(
                 // decoration: BoxDecoration(border:Border.all(color:Colors.black)),
                  height: path.isNotEmpty && !play?0:100,
                ): GestureDetector(
                  child: CircleAvatar(
                      backgroundColor: staticColor,
                      radius: 30,
                      child: Icon(Icons.mic)),
                  onTap: (){
                   showToast("please hold to record");
                   setState(() {
                     play = false;
                     path = "";
                   });
                   sl<Cases>().stopRecord();

                  },
                  onPanDown: (d) async {
                  print(d);
                  setState(() {
                    play = true;
                  });
                  path = await sl<Cases>().startRecord(time.toString());
                  print('path:::: $path');
                  },
                  onLongPressEnd: (d) {
                    print(d);
                    setState(() {
                      play = false;
                    });
                    sl<Cases>().stopRecord();
                  }
                ),
              ),
            );
          });
        });
    if (refresh == true) {
      getData();
    }
  }

}
