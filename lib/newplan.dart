import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yi_daily_plan/persistentstorage.dart';

class NewPlanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AddPlanState();
  }
}

enum barItem { DAY, WEEK, MONTH, YEAR }

class AddPlanState extends State<NewPlanPage> {
  bool isAdd=true;
  String inputText = "";
  String inputIcon = 'assets/jewelry.png';
  int inputFrequency = 0;
  int selectedCircle = 0;
  List<String> barName = ["天", "周", "月", "年"];
  List ic = [
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
    'assets/jewelry.png',
  ];
  List iv = [
    "1111",
    "2222",
    "3333",
    "1114",
    "2225",
    "3336",
    "1117",
    "2228",
    "3339",
    "11110",
    "22211",
    "33312",
    "11113",
    "22214",
    "33315",
    "11116",
    "22217",
    "33318",
    "11119",
    "22220",
    "33321",
    "11122",
    "22223",
    "33324",
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("New a Plan"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.check),
            onPressed: () {
              savePlan();
            },
          )
        ],
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new SizedBox(
                width: 72,
                child: new TextButton(
                  child: new Row(
                    children: [
                      new Image.asset(
                        inputIcon,
                        height: 32,
                        width: 32,
                      ),
                      new Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              new Expanded(
                  child: new Container(
                child: new TextField(
                    decoration: InputDecoration(
                      labelText: '计划名称',
                      labelStyle: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                          gapPadding: 0,
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0)),
                      focusedBorder: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: new BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                    cursorColor: Colors.black,
                    maxLength: 8,
                    onChanged: (value) {
                      this.inputText = value;
                    },
                    controller: TextEditingController.fromValue(TextEditingValue(
                        text: '${this.inputText == null ? "" : this.inputText}',
                        selection: TextSelection.fromPosition(TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: '${this.inputText}'.length))))),
                padding:
                    const EdgeInsets.only(left: 5.0, right: 20.0, top: 10.0),
              )),
            ],
          ),
          new SizedBox(
            height: 58,
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new Container(
                  child: new Text(
                    "周期:   每",
                    style: new TextStyle(fontSize: 20),
                  ),
                  margin: const EdgeInsets.only(left: 35),
                ),
                new Card(
                    color: null,
                    shadowColor: null,
                    shape: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.amber, width: 2),
                    ),
                    child: new PopupMenuButton<barItem>(
                        child: new Text(
                          " " + barName[selectedCircle] + "  ",
                          style: new TextStyle(fontSize: 20),
                        ),
                        onSelected: (barItem result) {
                          setState(() {
                            selectedCircle = result.index;
                          });
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<barItem>>[
                              const PopupMenuItem<barItem>(
                                value: barItem.DAY,
                                child: Text("天"),
                              ),
                              const PopupMenuItem<barItem>(
                                value: barItem.WEEK,
                                child: Text("周"),
                              ),
                              const PopupMenuItem<barItem>(
                                  value: barItem.MONTH, child: Text('月')),
                              const PopupMenuItem<barItem>(
                                  value: barItem.YEAR, child: Text('年')),
                            ])),
                targetJudge(),
              ],
            ),
          ),
          new Expanded(
              child: new Container(
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 12.0, bottom: 12, top: 12),
                  child: new Card(
                    shape: new BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: new BorderSide(color: Colors.black54),
                    ),
                    child: new GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 2.4,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                        top: 10.0,
                      ),
                      mainAxisSpacing: 3.5,
                      crossAxisSpacing: 3.5,
                      children: gridItemBuild(
                          ic.length > iv.length ? iv.length : ic.length),
                    ),
                  )))
        ],
      ),
    );
  }

  List<Widget> gridItemBuild(int num) {
    List<Widget> w = [];
    for (int i = 0; i < num; i++) {
      w.add(gridItem(i));
    }
    return w;
  }

  Widget gridItem(int num) {
    return new Card(
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: new BorderSide(color: Colors.black54, width: 2),
      ),
      child: new Container(
        child: new TextButton(
          onPressed: () {
            sendInputLine(num);
          },
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Image.asset(
                ic[num],
                height: 24,
              ),
              new Container(
                padding: const EdgeInsets.only(left: 5),
                child: new Text(
                  iv[num],
                  style: new TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget targetJudge() {
    if (selectedCircle == 0) {
      inputFrequency = 0;
    } else if (selectedCircle == 1) {
      inputFrequency = 5;
    } else if (selectedCircle == 2) {
      inputFrequency = 21;
    } else if (selectedCircle == 3) {
      inputFrequency = 300;
    }
    return selectedCircle == 0
        ? new Container()
        : new Row(
            children: [
              new Container(
                margin: const EdgeInsets.only(left: 25),
                width: 35,
                child: new TextField(
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: selectedCircle,
                  onChanged: (result){
                    inputFrequency=int.parse(result);
                  },
                  controller: TextEditingController.fromValue(TextEditingValue(
                      text: inputFrequency.toString(),
                      selection: TextSelection.fromPosition(TextPosition(
                          affinity: TextAffinity.downstream,
                          offset: '${this.inputFrequency}'.length)))),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.amber, width: 2.1)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.amberAccent, width: 2.1),
                    ),
                  ),
                ),
              ),
              new Text(
                barName[0],
                style: new TextStyle(fontSize: 20),
              ),
            ],
          );
  }
  void sendInputLine(int num) {
    setState(() {
      inputText = iv[num];
      inputIcon = ic[num];
    });
  }

  void savePlan() async{
    if(inputText.isEmpty){
      showMyToast("Title can not be empty.");
      return;
    }
    if(selectedCircle==1&&inputFrequency>7){
      showMyToast("There are only 7 days in a week at most.");
      return;
    }
    if(selectedCircle==2&&inputFrequency>31){
      showMyToast("There are only 31 days in a month at most.");

      return;
    }
    if(selectedCircle==3&&inputFrequency>365){
      showMyToast("You are only allowed to set 365 days in a year frequency.");
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if( prefs.containsKey(inputText)){
      showMyToast("There is already had same plan, you can change a name of this plan.");
      return;
    }

    List<String> startData=[];
    startData.add(inputIcon);
    startData.add("$selectedCircle-$inputFrequency");

    prefs.setStringList(inputText, startData);
    Navigator.pop(context, true);
  }
  void showMyToast(String text){
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
