import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewPlanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AddPlanState();
  }
}

class AddPlanState extends State<NewPlanPage> {
  int i = 0;
  String inputText = "";
  IconData inputIcon=Icons.today;
  List ic = [
    Icons.today,
    Icons.style,
    Icons.list,
    Icons.today,
    Icons.style,
    Icons.list,
    Icons.today,
    Icons.style,
    Icons.list,
    Icons.today,
    Icons.style,
    Icons.list,
    Icons.today,
    Icons.style,
    Icons.list,
    Icons.today,
    Icons.style,
    Icons.list,
    Icons.today,
    Icons.style,
    Icons.list,
    Icons.today,
    Icons.style,
    Icons.list,
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
      appBar: new AppBar(
        title: new Text("New a Plan"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Card(
                shape: new CircleBorder(
                  side: new BorderSide(color: Colors.black, width: 2),
                ),
                child: new IconButton(
                  icon: new Icon(inputIcon),
                  onPressed: () {},
                ),
              ),
              new Expanded(
                  child: new Container(
                child: new TextField(
                    decoration: InputDecoration(
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
              ))
            ],
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
                      children: gridItemBuild(ic.length>iv.length?iv.length:ic.length),
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
    i++;
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
              new Icon(
                ic[num],
                color: Colors.black,
              ),
              new Container(
                padding: const EdgeInsets.only(left: 5),
                child: new Text(
                iv[num],
                style: new TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),)

            ],
          ),
        ),
      ),
    );
  }

  void sendInputLine(int num) {
    setState(() {
      inputText = iv[num];
      inputIcon=ic[num];
    });
  }
}
