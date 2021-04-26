import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPlanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AddPlanState();
  }
}

enum barItem { DAY, WEEK, MONTH, YEAR }

class AddPlanState extends State<NewPlanPage> {
  bool isAdd = true;
  String inputText = "";
  String inputIcon = 'assets/icon22_purenatural.png';
  int inputFrequency = 0;
  int selectedCircle = 0;
  List<String> barName = ["天", "周", "月", "年"];
  List ic = [
    'assets/icon0_muscle.png',
    'assets/icon1_sun.png',
    'assets/icon2_moon.png',
    'assets/icon3_running.png',
    'assets/icon4_writing.png',
    'assets/icon5_egg.png',
    'assets/icon6_barbecue.png',
    'assets/icon8_icecream.png',
    'assets/icon9_endocrine.png',
    'assets/icon10_anti_corrosion.png',
    'assets/icon11_fruit.png',
    'assets/icon12_milkjuice.png',
    'assets/icon13_game.png',
    'assets/icon14_sport.png',
    'assets/icon15_balanceweight.png',
    'assets/icon16_twocode.png',
    'assets/icon18_beer.png',
    'assets/icon19_comments.png',
    'assets/icon20_book.png',
    'assets/icon22_purenatural.png',
    'assets/icon24_teeth.png',
    'assets/icon25_thinking.png',
    'assets/icon26_candy.png',
    'assets/icon28_skin.png',
    'assets/icon7_code.png',
    'assets/icon17_chafing_dish.png',
    'assets/icon001_game2.png',
    'assets/icon002_message.png',
    'assets/icon003_love.png',

  ];
  List iv = [
    "健身",
    "早起",
    "早睡",
    "跑步",
    "写作",
    "吃早餐",
    "戒夜宵",
    "戒零食",
    "戒撸",
    "八杯水",
    "吃水果",
    "戒奶茶",
    "戒游戏",
    "运动",
    "减重",
    "学英语",
    "戒酒",
    "不联系ta",
    "看书",
    "浇花",
    "刷牙",
    "冥想",
    "戒糖",
    "护肤",
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
                  onPressed: () {
                    iconMarketDialog();
                  },
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
          new Container(
            margin: const EdgeInsets.only(top: 15),
            child: new Text(
              "常用计划",
              style: new TextStyle(color: Colors.blueAccent),
            ),
          ),
          new Expanded(
              child: new Container(
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 12.0, bottom: 12),
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
                      mainAxisSpacing: 2,
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

  List<Widget> iconRowItem(int num){
    List<Widget> list=[];
    for(int i=0;i<4&&i<ic.length-num;i++){
      list.add(new TextButton(
        onPressed: () {
          setState(() {
            inputIcon=ic[i+num];
          });
          Navigator.pop(context);
        },
        child: new Image.asset(
          ic[i+num],
          height:28,
          width: 28,
        ),
      ),);
    }
    return list;
  }
  iconMarketDialog() async {
    List<Widget> iconList = [];
    for (int i = 0; i < ic.length; i+=4) {
        iconList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: iconRowItem(i),
        ));
    }
    return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(

            children: iconList,
          );
        });
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
                  onChanged: (result) {
                    inputFrequency = int.parse(result);
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

  void savePlan() async {
    if (inputText.isEmpty) {
      showMyToast("Title can not be empty.");
      return;
    }
    if (selectedCircle == 1 && inputFrequency > 7) {
      showMyToast("There are only 7 days in a week at most.");
      return;
    }
    if (selectedCircle == 2 && inputFrequency > 31) {
      showMyToast("There are only 31 days in a month at most.");
      return;
    }
    if (selectedCircle == 3 && inputFrequency > 365) {
      showMyToast("You are only allowed to set 365 days in a year frequency.");
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(inputText)) {
      showMyToast(
          "There is already had same plan, you can change a name of this plan.");
      return;
    }

    List<String> startData = [];
    startData.add(inputIcon); //list[0]图标
    startData.add("$selectedCircle-$inputFrequency"); //list[1] 频率（天周月年 - 天）
    startData.add(DateTime.now().toString().substring(0, 10)); //list[2]创建日期
    startData.add("value1"); //预置数据位
    startData.add("value2");
    prefs.setStringList(inputText, startData);
    Navigator.pop(context, true);
  }

  void showMyToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
