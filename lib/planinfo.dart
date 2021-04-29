import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          shape: new RoundedRectangleBorder(
              side: new BorderSide(width: 3, color: Colors.amber),
              borderRadius: new BorderRadius.all(new Radius.circular(20))),
          backgroundColor: Colors.amberAccent,
        ),
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
          ],
        ));
  }

  Widget progress() {
    if (frequency == 0) return new Container();
    return new Container(
        child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        new Container(
          child: new Text(
            frequency==1?"本周已完成$progressDay天":"已完成$finishedFrequency个周期，当前周期进度$progressDay/$frequencyDay",
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

  void getCircle(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    titleIcon = sharedPreferences.getStringList(key)[0];
    frequency =
        int.parse(sharedPreferences.getStringList(key)[1].substring(0, 1));
    frequencyDay =
        int.parse(sharedPreferences.getStringList(key)[1].substring(2));

    var tempList = sharedPreferences.getStringList(key).sublist(5);

    tempList.sort((left, right) => left.compareTo(right));
    int numerator = 0;

    for (int i = tempList.length >=
                (frequency == 2 ? DateTime.now().day : daysCalculateUtil(2))
            ? tempList.length - numerator
            : 0;
        i < tempList.length;
        i++) {
      if (int.parse(tempList[i]) > DateTime.now().year * 10000) {
        numerator = tempList.length - i;
        break;
      }
    }
    progressDay = numerator;
    int tempFre=0;
    int temp=0;
    int stringSub=0;
    for (int i = 0; i < tempList.length; i++) {
      list.add(int.parse(tempList[i]));
      if(frequency==2){
         stringSub=int.parse(tempList[i].substring(4,6));
      }else if(frequency==3){
        stringSub=int.parse(tempList[i].substring(0,4));
      }
      if(temp==stringSub){
        tempFre++;
      }else{
        if(tempFre>=frequencyDay){
          finishedFrequency++;
        }
        tempFre=0;
      }
      temp=stringSub;
    }
    if (isStart) {
      isStart = false;
      setState(() {});
    }
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
}
