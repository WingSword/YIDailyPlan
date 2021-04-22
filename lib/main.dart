import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:yi_daily_plan/newplan.dart';

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
  final wordPair = <WordPair>[];
  final biggerFont = const TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
  final saveCard = new Set<String>();
  final saveDate = new Map<String, Set<String>>();
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

  @override
  Widget build(BuildContext context) {
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
              Navigator.pushNamed(context, '/newPlan');
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
                      child: Text('111'),
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

  void pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = saveCard.map(
            (pair) {
              return new Card(
                  child: new ListTile(
                title: new Text(
                  pair.toString(),
                  style: biggerFont,
                ),
              ));
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Daily Plan'),
            ),
            body: new ListView(
              children: divided,
            ),
          );
        },
      ),
    );
  }

  Widget buildSuggestion() {
    return new ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, i) {
          if (i >= wordPair.length)
            wordPair.addAll(generateWordPairs().take(10));
          return buildListRaw(wordPair[i]);
        });
  }

  Widget buildItemCalender(WordPair w, int weekday) {
    final bool isCheck = saveDate.containsKey(w.toString()) &&
        saveDate[w.toString()].contains(dateCalculate(weekday, true));
    return new Container(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
      child: new Column(
        children: [
          new Text((dateCalculate(weekday, false)).toString(),
              style: new TextStyle(fontSize: 16)),
          new Icon(
            isCheck ? Icons.wb_sunny : Icons.wb_sunny_outlined,
            size: 20,
          )
        ],
      ),
    );
  }

  Widget buildListRaw(WordPair w) {
    final alreadySaved = saveDate.containsKey(w.toString()) &&
        saveDate[w.toString()]
            .contains(dateCalculate(DateTime.now().weekday, true));
    return new Card(
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
                    padding: const EdgeInsets.only(bottom: 2.0, left: 12.0),
                    child: new Text(
                      w.asPascalCase,
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
                      child: new Row(
                        children: [
                          buildItemCalender(w, 1),
                          buildItemCalender(w, 2),
                          buildItemCalender(w, 3),
                          buildItemCalender(w, 4),
                          buildItemCalender(w, 5),
                          buildItemCalender(w, 6),
                          buildItemCalender(w, 7),
                        ],
                      )),
                  new Container(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                    child: new Text(
                        "Insisted on " +
                            (saveDate.containsKey(w.toString())
                                ? saveDate[w.toString()].length.toString()
                                : "0") +
                            " days",
                        style: new TextStyle(
                            color: Colors.blueGrey, fontSize: 15)),
                  ),
                ]))
          ],
        ),
        trailing: new IconButton(
          icon: new Icon(alreadySaved
              ? Icons.assignment_turned_in
              : Icons.assignment_turned_in_outlined),
          iconSize: 36,
          color: alreadySaved ? Colors.green : Colors.black,
          onPressed: () {
            setState(() {
              if (alreadySaved) {
                if (saveDate.containsKey(w.toString())) {
                  saveDate[w.toString()].remove(currentDate);
                }
                saveCard.remove(w.toString());
              } else {
                Set<String> tempSet = new Set();
                if (saveDate.containsKey(w.toString())) {
                  saveDate[w.toString()].add(currentDate);
                } else {
                  tempSet.add(currentDate);
                  saveDate.putIfAbsent(w.toString(), () => tempSet);
                }
                saveCard.add(w.toString());
              }
            });
          },
        ),
        onTap: () {
          setState(() {
            gotoPlanInfo(w);
          });
        },
        onLongPress: () {},
      ),
    );
  }

  void menuDeal(barItemName bar) {
    if (bar == barItemName.one) {
      pushSaved();
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

  void gotoPlanInfo(WordPair w) {}
}
