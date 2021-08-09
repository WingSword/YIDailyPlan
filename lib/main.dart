import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yi_daily_plan/Adapt.dart';
import 'package:yi_daily_plan/model.dart';
import 'package:yi_daily_plan/newplan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:like_button/like_button.dart';
import 'package:yi_daily_plan/planinfo.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      initialRoute: "/",
      title: 'Welcome to Flutter',
      theme: new ThemeData(primaryColor: Colors.white),
      //home: new HomePage(),
      routes: <String, WidgetBuilder>{
        "/": (context) => HomePage(), //注册首页路由
        '/newPlan': (BuildContext context) => NewPlanPage(),
        '/planInfo': (BuildContext context) => PlanInfoPage()
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  createState() => new HomePageState();
}

enum barItemName { one, two, three }

class HomePageState extends State<HomePage> {
  String focusedTitle = "";
  bool appStart = true;
  List<String> allItemTitle = [];
  int currentPage = 1;
  String currentTitle = "专注";
  Map allItem = new Map<String, List<String>>();
  final headCount = 5;
  var mavUri;
  final monthEnglish = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final currentDate = DateTime.now().year.toString() +
      (DateTime.now().month < 10
          ? "0" + DateTime.now().month.toString()
          : DateTime.now().month.toString()) +
      (DateTime.now().day < 10
          ? "0" + DateTime.now().day.toString()
          : DateTime.now().day.toString());
  final DateTime currentTime = DateTime.now();

  void refreshListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    allItemTitle = [];
    allItem.clear();
    if (prefs.getKeys() != null && prefs.getKeys().isNotEmpty) {
      allItemTitle.addAll(prefs.getKeys().toList());
      for (String str in allItemTitle) {
        allItem.putIfAbsent(str, () => prefs.getStringList(str));
      }
    }
    if (appStart) {
      appStart = false;
      setState(() {});
    }
  }

  void changeItemData(String key, bool isDeleteItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDeleteItem ? prefs.remove(key) : prefs.setStringList(key, allItem[key]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    refreshListData();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          currentPage == 1
              ? monthEnglish[currentTime.month - 1] +
                  "." +
                  currentTime.day.toString()
              : currentTitle,
          style: new TextStyle(color: Colors.black),
        ),
        shape: new RoundedRectangleBorder(
            side: new BorderSide(width: 3, color: Colors.amber),
            borderRadius: new BorderRadius.all(new Radius.circular(20))),
        backgroundColor: Colors.amberAccent,
      ),
      body: buildSuggestion(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/newPlan').then((value) {
            refreshListData();
            setState(() {});
          });
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber,
        child: new Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
        child: new Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.today,
                color: currentPage == 1 ? Colors.teal : Colors.black,
              ),
              onPressed: () {
                currentPage = 1;
                setState(() {});
              },
            ),
            SizedBox(), //中间位置空出
            IconButton(
              icon: Icon(
                Icons.access_alarm,
                color: currentPage == 2 ? Colors.teal : Colors.black,
              ),
              onPressed: () {
                currentPage = 2;
                setState(() {});
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
        ),
      ),
    );
  }

  Widget buildSuggestion() {
    if (currentPage == 1) {
      return new Stack(
        children: [
          new ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: allItemTitle.length,
              itemBuilder: (context, i) {
                return buildListRaw(allItemTitle[i]);
              }),
        ],
      );
    } else if (currentPage == 2) {
      return new Container(
        alignment: Alignment.center,
        child: new TextButton(
            onPressed: () {},
            child: new Container(
                width: Adapt.px(520),
                height: Adapt.px(520),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(25),
                decoration: new BoxDecoration(
                  color: Colors.lightBlue,
                  border: new Border.all(width: 3, color: Colors.deepOrange),
                  borderRadius: new BorderRadius.all(Radius.circular(150)),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text(
                      "25:00",
                      style: new TextStyle(fontSize: 80, color: Colors.white),
                    ),
                    new Text(
                      "zhuanzhu",
                      style: new TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ))),
      );
    }
  }

  List<Widget> buildItemCalender(String title) {
    List<Widget> calenderInThisWeek = [];
    for (int weekday = 1; weekday <= 7; weekday++) {
      calenderInThisWeek.add(new Container(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: new Column(
          children: [
            new Text((dateCalculate(weekday, false)),
                style: new TextStyle(
                    fontSize: 16,
                    color: int.parse(dateCalculate(weekday, false)) ==
                            currentTime.day
                        ? Colors.amber
                        : Colors.blueGrey)),
            new Icon(
                allItem.containsKey(title) &&
                        allItem[title].contains(dateCalculate(weekday, true))
                    ? Icons.wb_sunny
                    : Icons.wb_sunny_outlined,
                size: 20,
                color:
                    int.parse(dateCalculate(weekday, false)) == currentTime.day
                        ? Colors.amber
                        : Colors.blueGrey)
          ],
        ),
      ));
    }
    return calenderInThisWeek;
  }

  Widget buildListRaw(String title) {
    final alreadyCheckedToday =
        allItem[title].contains(dateCalculate(DateTime.now().weekday, true));
    return new Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      padding: EdgeInsets.only(top: 3),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(new Radius.circular(5)),
        image: new DecorationImage(
          image: new AssetImage(allItem[title][3]),
          fit: BoxFit.cover,
        ),
      ),
      child: new Stack(
        children: [
          new Offstage(
            offstage: false,
            child: new TextButton(
              child: new Row(
                children: [
                  new Container(
                    child: new Image.asset(
                      allItem[title][0],
                      height: 28,
                    ),
                    decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(20)),
                        border:
                            new Border.all(color: Colors.black54, width: 2.5),
                        color: Colors.white70),
                    padding: const EdgeInsets.all(2),
                  ),
                  new Expanded(
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        new Container(
                          padding:
                              const EdgeInsets.only(bottom: 2.0, left: 12.0),
                          child: new Text(
                            title,
                            style: new TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        new Container(
                            decoration:
                                new BoxDecoration(color: Colors.white54),
                            margin: const EdgeInsets.all(2),
                            padding: const EdgeInsets.only(
                                bottom: 5.0, left: 12.0, top: 5.0),
                            child: new Row(children: buildItemCalender(title))),
                        insistedCountView(title)
                      ])),
                  new LikeButton(
                    isLiked: alreadyCheckedToday,
                    likeBuilder: (bool isLiked) {
                      return new Icon(
                        isLiked ? Icons.fact_check : Icons.fact_check_outlined,
                        size: 32,
                      );
                    },
                    onTap: (bool isLiked) async {
                      setState(() {
                        isLiked
                            ? allItem[title].remove(currentDate)
                            : allItem[title].add(currentDate);
                        changeItemData(title, false);
                      });
                      return !isLiked;
                    },
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  if (focusedTitle == title)
                    focusedTitle = "";
                  else
                    Navigator.of(context)
                        .pushNamed("/planInfo", arguments: title)
                        .then((value) {
                      appStart = true;
                      print("object:$appStart");
                      refreshListData();
                    });
                });
              },
              onLongPress: () {
                setState(() {
                  focusedTitle = focusedTitle == title ? "" : title;
                });
              },
            ),
          ),
          itemTapMenu(title)
        ],
      ),
    );
  }

  Widget insistedCountView(String title) {
    return new Container(
      decoration: new BoxDecoration(
          color: Colors.black54,
          borderRadius: new BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.all(3),
      child: new Text("已坚持 ${allItem[title].length - headCount} 天",
          style: new TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget itemTapMenu(String title) {
    return new Offstage(
      offstage: focusedTitle == title ? false : true,
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: itemTap(title, [
              "编辑",
              "删除",
              "补卡"
            ], [
              Icons.edit_outlined,
              Icons.delete_sweep_outlined,
              Icons.access_alarm
            ])),
      ),
    );
  }

  List<Widget> itemTap(
      String title, List<String> allItemText, List<IconData> allItemIcon) {
    List<Widget> itemTapList = [];
    var tapColor = [
      Colors.blueAccent,
      Colors.deepOrangeAccent,
      Colors.greenAccent,
      Colors.amberAccent,
    ];
    int circleTime = min(allItemText.length, allItemIcon.length);
    for (int i = 0; i < circleTime; i++) {
      itemTapList.add(new Container(
        height: 85,
        width: 40,
        margin: const EdgeInsets.only(right: 1),
        child: new TextButton(
          style: new ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => tapColor[i % 4]),
            // shape: MaterialStateProperty.resolveWith((states) => new RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(5.0),
            //   side: new BorderSide(color: Colors.black54, width: 2),
            // ),
            // )
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Icon(
                allItemIcon[i],
                color: Colors.white,
                size: 24,
              ),
              new Text(
                allItemText[i],
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            ],
          ),
          onPressed: () {
            itemTapMenuDeal(title, i);
          },
        ),
      ));
    }
    return itemTapList;
  }

  void itemTapMenuDeal(String title, int index) {
    if (index == 0) {
      //编辑
      changePlanBg(title);
    } else if (index == 1) {
      //删除
      allItem.remove(title);
      allItemTitle.remove(title);
      changeItemData(title, true);
    } else if (index == 2) {
      makeUpPlan(title);
    }
    focusedTitle = "";
    setState(() {});
  }

  void menuDeal(barItemName bar) {
    if (bar == barItemName.one) {
      //pushSaved();
    }
  }

  String dateCalculate(int weekday, bool all) {
    if (currentTime.day - currentTime.weekday + weekday > 0) {
      return all
          ? (currentTime.year * 10000 +
                  currentTime.month * 100 +
                  (currentTime.day - currentTime.weekday + weekday))
              .toString()
          : (currentTime.day - currentTime.weekday + weekday).toString();
    }
    int dayOfMonth = 31;
    if (currentTime.month - 1 == 4 ||
        currentTime.month - 1 == 6 ||
        currentTime.month - 1 == 9 ||
        currentTime.month - 1 == 11) {
      dayOfMonth--;
    }
    if (currentTime.month - 1 == 2) {
      dayOfMonth = 28;
      if (currentTime.year % 4 == 0 &&
          (currentTime.year % 100 != 0 || currentTime.year % 400 == 0))
        dayOfMonth = 29;
    }
    int tempYear =
        currentTime.month == 1 ? currentTime.year - 1 : currentTime.year;
    int tempMonth = 12;
    if (currentTime.month != 1) {
      tempMonth = currentTime.month - 1;
    }
    return all
        ? (tempYear * 10000 +
                tempMonth * 100 +
                (dayOfMonth + currentTime.day - currentTime.weekday + weekday))
            .toString()
        : (dayOfMonth + currentTime.day - currentTime.weekday + weekday)
            .toString();
  }

  String currentBg = ModelClass.bg[0];

  changePlanBg(String title) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return SimpleDialog(
                title: new Text("修改卡片背景"), children: bgItem(title, state));
          });
        });
  }

  List<Widget> bgItem(String title, Function cc) {
    List<Widget> bg = [];
    for (int i = 0; i < ModelClass.bg.length; i++) {
      bool isChecked = currentBg == ModelClass.bg[i];
      bg.add(new Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(10),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(5)),
            image: new DecorationImage(
              image: new AssetImage(ModelClass.bg[i]),
              fit: BoxFit.cover,
            ),
          ),
          child: TextButton(
            child: new Icon(isChecked
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank),
            onPressed: () {
              setState(() {
                currentBg = ModelClass.bg[i];
              });
              cc(() {});
            },
          )));
    }
    bg.add(new Container(
      child: new TextButton(
        child: new Text("确定"),
        onPressed: () {
          allItem[title][3] = currentBg;
          changeItemData(title, false);
          Navigator.pop(context);
          setState(() {});
        },
      ),
    ));
    return bg;
  }

  makeUpPlan(String title) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: new Row(
              children: [
                new Container(
                  child: new Image.asset(
                    allItem[title][0],
                    height: 28,
                  ),
                  decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(20)),
                      border: new Border.all(color: Colors.black54, width: 2.5),
                      color: Colors.white70),
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.only(right: 20),
                ),
                new Text("补卡: " + title),
              ],
            ),
            children: makeUpDialogItem(title),
          );
        });
  }

  List<Widget> makeUpDialogItem(String title) {
    List<Widget> list = [];
    final countOfMakeUp = 3;
    for (int i = 1; i <= countOfMakeUp; i++) {
      final alreadyChecked =
          allItem[title].contains(dateCalculate(currentTime.weekday - i, true));
      list.add(new Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.lime, width: 3),
            borderRadius: new BorderRadius.all(new Radius.circular(5)),
            color: Colors.white30),
        child: new TextButton(
          onPressed: () {},
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Container(
                child: new Text(
                  textChange(dateCalculate(currentTime.weekday - i, true)),
                  style:
                      new TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                margin: const EdgeInsets.only(left: 20),
              ),
              new Container(
                margin: const EdgeInsets.only(right: 10),
                child: new LikeButton(
                  isLiked: alreadyChecked,
                  likeBuilder: (bool isLiked) {
                    return new Icon(
                      isLiked ? Icons.check_circle : Icons.check_circle_outline,
                      size: 32,
                    );
                  },
                  circleColor:
                      CircleColor(start: Colors.green, end: Colors.greenAccent),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Colors.lightGreenAccent,
                    dotSecondaryColor: Colors.lightGreen,
                  ),
                  onTap: (bool isLiked) async {
                    setState(() {
                      isLiked
                          ? allItem[title].remove(
                              dateCalculate(currentTime.weekday - i, true))
                          : allItem[title].add(
                              dateCalculate(currentTime.weekday - i, true));
                      changeItemData(title, false);
                    });
                    return !isLiked;
                  },
                ),
              )
            ],
          ),
        ),
      ));
    }
    return list;
  }

  int wavi = 0;

  String textChange(String date) {
    if (int.parse(dateCalculate(currentTime.weekday, true)) - int.parse(date) ==
        1) {
      return "昨天";
    }
    if (int.parse(dateCalculate(currentTime.weekday, true)) - int.parse(date) ==
        2) {
      return "前天";
    }
    if (int.parse(dateCalculate(currentTime.weekday, true)) - int.parse(date) ==
        -1) {
      return "明天";
    }
    if (int.parse(dateCalculate(currentTime.weekday, true)) - int.parse(date) ==
        -2) {
      return "后天";
    }
    if (int.parse(dateCalculate(currentTime.weekday, true)) - int.parse(date) ==
        0) {
      return "今天";
    }
    return "${date.substring(0, 4)}年${date.substring(4, 6)}月${date.substring(6)}日";
  }
}
