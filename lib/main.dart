import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yi_daily_plan/newplan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:like_button/like_button.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(primaryColor: Colors.white),
      home: new HomePage(),
      routes: <String, WidgetBuilder>{
        '/newPlan': (BuildContext context) => NewPlanPage(),
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
  final List<String> allItemTitle = [];
  final allItem = new Map<String, List<String>>();
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
      DateTime.now().month.toString() +
      DateTime.now().day.toString();
  final DateTime currentTime = DateTime.now();

  void refreshListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getKeys() != null && prefs.getKeys().isNotEmpty) {
      allItemTitle.clear();
      allItemTitle.addAll(prefs.getKeys().toList());
      for (String str in allItemTitle) {
        allItem.putIfAbsent(str, () => prefs.getStringList(str));
      }
    }
  }

  void changeItemData(String key, bool isDeleteItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove(key);
    if (!isDeleteItem) prefs.setStringList(key, allItem[key]);
  }

  @override
  Widget build(BuildContext context) {
    refreshListData();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          monthEnglish[currentTime.month - 1] +
              "." +
              currentTime.day.toString(),
          style: new TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/newPlan').then((value) {
                refreshListData();
                setState(() {});
              });
            },
            color: Colors.black,
            iconSize: 32,
          ),
          new PopupMenuButton<barItemName>(
              icon: new Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
              iconSize: 28,
              onSelected: (barItemName result) {
                setState(() {
                  menuDeal(result);
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<barItemName>>[
                    const PopupMenuItem<barItemName>(
                      value: barItemName.one,
                      child: Text('统计'),
                    ),
                    const PopupMenuItem<barItemName>(
                        value: barItemName.two, child: Text('222')),
                    const PopupMenuItem<barItemName>(
                        value: barItemName.three, child: Text('333')),
                  ])
        ],
      ),
      body: buildSuggestion(),
    );
  }

  Widget buildSuggestion() {
    print("当前item数：${allItemTitle.length}---${DateTime.now()}");
    return new ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: allItemTitle.length,
        itemBuilder: (context, i) {
          return buildListRaw(allItemTitle[i]);
        });
  }

  List<Widget> buildItemCalender(String title) {
    List<Widget> calenderInThisWeek = [];
    for (int weekday = 1; weekday <= 7; weekday++) {
      calenderInThisWeek.add(new Container(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: new Column(
          children: [
            new Text((dateCalculate(weekday, false)).toString(),
                style: new TextStyle(fontSize: 16)),
            new Icon(
              allItem.containsKey(title) &&
                      allItem[title].contains(dateCalculate(weekday, true))
                  ? Icons.wb_sunny
                  : Icons.wb_sunny_outlined,
              size: 20,
            )
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
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(new Radius.circular(5)),
        image: new DecorationImage(
          image: new AssetImage("assets/bg_item_004.jpg"),
          fit: BoxFit.cover,
          //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
        ),
      ),
      child: new Stack(
        children: [
          new Offstage(
            offstage: false,
            child: new ListTile(
              title: new Row(
                children: [
                  new Image.asset(
                    'assets/jewelry.png',
                    height: 28,
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
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        new Container(
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

                    // onPressed: () {
                    //   setState(() {
                    //     alreadyCheckedToday
                    //         ? allItem[title].remove(currentDate)
                    //         : allItem[title].add(currentDate);
                    //     changeItemData(title, false);
                    //   });
                    // },
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  focusedTitle = focusedTitle == title ? "" : title;
                });
              },
              onLongPress: () {},
            ),
          ),
          itemTapMenu(title)
        ],
      ),
    );
  }

  Widget insistedCountView(String title) {
    return new Container(
      padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
      child: new Text("Insisted on ${allItem[title].length - 2} days",
          style: new TextStyle(color: Colors.black, fontSize: 15)),
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
      gotoPlanInfo(title);
    } else if (index == 1) {
      //删除
      allItem.remove(title);
      allItemTitle.remove(title);
      changeItemData(title, true);
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
          ? currentTime.year.toString() +
              currentTime.month.toString() +
              (currentTime.day - currentTime.weekday + weekday).toString()
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
    int tempMonth = currentTime.month == 1 ? 12 : currentTime.month - 1;
    return all
        ? tempYear.toString() +
            tempMonth.toString() +
            (dayOfMonth + currentTime.day - currentTime.weekday + weekday)
                .toString()
        : (dayOfMonth + currentTime.day - currentTime.weekday + weekday)
            .toString();
  }

  void gotoPlanInfo(String w) {}
}
