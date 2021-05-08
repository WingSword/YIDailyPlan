import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'main.dart';

class PlanInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlanInfoState();
  }
}

class PlanInfoState extends State<PlanInfoPage> {
  List<int> list = [];
  int frequency = 0;
  int frequencyDay = 0;
  int progressDay = 0;
  int finishedFrequency = 0;
  String titleName = "";
  String titleIcon = '';
  bool isStart = true;
  int validDay = 3;

  @override
  Widget build(BuildContext context) {
    //获取路由参数
    titleName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: new AppBar(
          title: new TextButton(
              onPressed: () {
                print('button click');
              },
              //如果不手动设置icon和text颜色,则默认使用foregroundColor颜色
              child: new Row(
                children: [
                  new Container(
                    margin: const EdgeInsets.only(left: 5, right: 25),
                    child: new Image.asset(
                      titleIcon == "" ? "assets/icon1_sun.png" : titleIcon,
                      height: 32,
                    ),
                  ),
                  new Text(titleName,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      maxLines: 1),
                ],
              )),
          actions: <Widget>[
            new PopupMenuButton<barItemName>(
                iconSize: 28,
                onSelected: (barItemName result) {
                  if (result.index == 0) {
                  } else if (result.index == 1) {
                  } else if (result.index == 2) {
                    giveUpPlan();
                    Navigator.pop(context, true);
                  }
                  setState(() {});
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<barItemName>>[
                      const PopupMenuItem<barItemName>(
                        value: barItemName.one,
                        child: Text('修改当前计划名称或图标'),
                      ),
                      const PopupMenuItem<barItemName>(
                          value: barItemName.two, child: Text('补卡')),
                      const PopupMenuItem<barItemName>(
                          value: barItemName.three, child: Text('放弃计划')),
                    ])
          ],
          shape: new RoundedRectangleBorder(
              side: new BorderSide(width: 3, color: Colors.amber),
              borderRadius: new BorderRadius.all(new Radius.circular(20))),
          backgroundColor: Colors.amberAccent,
        ),
        backgroundColor: Colors.white,
        body: planInfoBody());
  }

  Widget planInfoBody() {
    getCircle(titleName);
    return new Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.topCenter,
        child: new Column(
          children: [
            progress(),
            calender(),
          ],
        ));
  }

  Widget progress() {
    if (frequency == 0)
      return new Container(
        child: new Text(
          "${list.contains(DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day) ? "今日已完成" : "今天还未完成"},已坚持${list.length}天，继续加油！",
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    return new Container(
        margin: EdgeInsets.only(bottom: 20),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            new Container(
              child: new Text(
                frequency == 1
                    ? "本周已完成$progressDay天"
                    : "已完成$finishedFrequency个周期，当前周期进度$progressDay/$frequencyDay${frequency == 2 ? "(每月)" : "(每年)"}",
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              margin: const EdgeInsets.only(right: 15),
            ),
            //进度条显示50%，会显示一个半圆
            new CircularProgressIndicator(
              strokeWidth: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(Colors.blue),
              value: progressDay / frequencyDay,
            ),
          ],
        ));
  }

  void giveUpPlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(titleName);
  }

  void changePlanState(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List tem0p = prefs.getStringList(titleName);
    if (tem0p.contains(key)) {
      tem0p.remove(key);
    } else {
      tem0p.add(key);
    }
    prefs.setStringList(titleName, tem0p);
  }

  Future<int> getCircle(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    titleIcon = sharedPreferences.getStringList(key)[0];
    frequency =
        int.parse(sharedPreferences.getStringList(key)[1].substring(0, 1));
    frequencyDay =
        int.parse(sharedPreferences.getStringList(key)[1].substring(2));

    var tempList = sharedPreferences.getStringList(key).sublist(5);
    tempList.sort((left, right) => left.compareTo(right));
    int numerator = 0;
    for (int i = tempList.length - 1;
        i >=
            (tempList.length - daysCalculateUtil(frequency == 2 ? 2 : 1) > 0
                ? tempList.length - daysCalculateUtil(frequency == 2 ? 2 : 1)
                : 0);
        i--) {
      if (int.parse(tempList[i]) >
          (frequency == 2
              ? DateTime.now().year * 10000 + DateTime.now().month * 100
              : DateTime.now().year * 10000)) {
        numerator++;
      }
    }
    progressDay = numerator;
    int tempFre = 0;
    int temp = 0;
    int stringSub = 0;
    for (int i = 0; i < tempList.length; i++) {
      if (list.contains(tempList[i])) {
        continue;
      }
      list.add(int.parse(tempList[i]));
      if (frequency == 2) {
        stringSub = int.parse(tempList[i].substring(4, 6));
      } else if (frequency == 3) {
        stringSub = int.parse(tempList[i].substring(0, 4));
      }
      if (temp == stringSub) {
        tempFre++;
      } else {
        if (tempFre >= frequencyDay) {
          finishedFrequency++;
        }
        tempFre = 0;
      }
      temp = stringSub;
    }
    if (isStart) {
      print("${DateTime.now()} 刷新：${list.length}");
      isStart = false;
      setState(() {});
    }
    return list.length;
  }

  //mode=1今年多少天,mode=2今天是今年第多少天,mode=0这个月多少天
  int daysCalculateUtil(int mode) {
    int yearDay = 365;
    if (DateTime.now().year % 4 == 0 && DateTime.now().year % 100 != 0 ||
        DateTime.now().year % 400 == 0) {
      yearDay++;
    }
    if (mode == 1) return yearDay;
    int monthDay = 31;
    if (DateTime.now().month == 4 ||
        DateTime.now().month == 6 ||
        DateTime.now().month == 9 ||
        DateTime.now().month == 11) monthDay = 30;
    if (DateTime.now().month == 2) monthDay = yearDay - 337;
    if (mode == 0) return monthDay;
    if (DateTime.now().month <= 7) {
      return (DateTime.now().month ~/ 2) * 31 +
          ((DateTime.now().month - 1) ~/ 2) * 30 +
          DateTime.now().day +
          (DateTime.now().month > 2 ? yearDay - 367 : 0);
    }
    return yearDay -
        184 +
        (DateTime.now().month - 6 - 1 * 30) +
        DateTime.now().day +
        ((DateTime.now().month - 7) ~/ 2);
  }

  final weekDays = ["日", "一", "二", "三", "四", "五", "六"];

  Widget calenderDay(DateTime day) {
    double dayRadius1 = 0;
    double dayRadius2 = 0;
    if (day.weekday == 7 ||
        (day.weekday != 7 &&
            !list.contains(day.year * 10000 + day.month * 100 + day.day - 1))) {
      dayRadius1 = 25;
    }
    if (day.weekday == 6 ||
        (day.weekday != 6 &&
            !list.contains(day.year * 10000 + day.month * 100 + day.day + 1))) {
      dayRadius2 = 25;
    }
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    list.contains(day.year * 10000 + day.month * 100 + day.day)
                        ? [Colors.lightBlueAccent, Colors.greenAccent[700]]
                        : [Colors.white, Colors.white]),
            borderRadius: new BorderRadius.horizontal(
                left: new Radius.circular(dayRadius1),
                right: new Radius.circular(dayRadius2))),
        child: Text(
          day.day.toString(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: day.toString().substring(0, 10) ==
                      DateTime.now().toString().substring(0, 10)
                  ? Colors.red
                  : Colors.black),
        ));
  }

  Widget calender() {
    return new Card(
        shape: new BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: new BorderSide(color: Colors.black54),
        ),
        child: new Container(
          padding: EdgeInsets.all(5),
          child: TableCalendar(
            firstDay: DateTime.utc(
                list.length > 0 ? list[0] ~/ 10000 : DateTime.now().year, 1, 1),
            lastDay:
                DateTime.utc(DateTime.now().year, DateTime.now().month, 31),
            focusedDay: DateTime.now(),
            headerStyle: new HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle:
                  new TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            calendarBuilders: CalendarBuilders(dowBuilder: (context, day) {
              return Center(
                child: Text(
                  weekDays[day.weekday % 7],
                  style: TextStyle(
                      color: day.weekday == DateTime.sunday ||
                              day.weekday == DateTime.saturday
                          ? Colors.red
                          : Colors.black),
                ),
              );
            }, defaultBuilder: (context, day, today) {
              return calenderDay(day);
            }, todayBuilder: (context, today, today2) {
              return calenderDay(today);
            }),
            onDayLongPressed: (date1, date2) {
              if (date1.isBefore(
                  DateUtils.addDaysToDate(DateTime.now(), -validDay))) {
                showMyToast("超过$validDay天不能补卡");
                return;
              }
              if (date1.isAfter(DateUtils.addDaysToDate(DateTime.now(), 1))) {
                showMyToast("只可补今日之前$validDay天的卡");
                return;
              }
              makeUpTip(date1);
            },
          ),
        ));
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

  makeUpTip(DateTime date) async {
    String card = "补";
    if (list.contains(date.year * 10000 + date.month * 100 + date.day)) {
      card = "取消";
    }
    return await showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text(
                "确定要$card${date.year}年${date.month}月${date.day}日的打卡吗？"),
            actions: <Widget>[
              TextButton(
                  child: Text("取消"),
                  onPressed: () => Navigator.pop(context, "cancel")),
              TextButton(
                  child: Text("确定"),
                  onPressed: () {
                    changePlanState(
                        (date.year * 10000 + date.month * 100 + date.day)
                            .toString());
                    if (list.contains(
                        (date.year * 10000 + date.month * 100 + date.day)))
                      list.remove(
                          (date.year * 10000 + date.month * 100 + date.day));
                    else
                      list.add(
                          (date.year * 10000 + date.month * 100 + date.day));
                    setState(() {});
                    Navigator.pop(context, "yes");
                  }),
            ],
          );
        });
  }
}
