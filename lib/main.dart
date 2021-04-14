import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(
        primaryColor: Colors.black
      ),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final wordPair = <WordPair>[];
  final biggerFont = const TextStyle(fontSize: 17);
  final saveCard = new Set<String>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('StartUp'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: pushSaved)
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
              return new ListTile(
                title: new Text(
                  pair.toString(),
                  style: biggerFont,
                ),
              );
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
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();
          final index = i ~/ 2;
          if (index >= wordPair.length)
            wordPair.addAll(generateWordPairs().take(10));
          return buildRaw(wordPair[index]);
        });
  }

  Widget buildRaw(WordPair w) {
    final alreadySaved = saveCard.contains(w.toString());
    return new ListTile(
      title: new Text(
        w.asPascalCase,
        style: biggerFont,
      ),
      trailing: new Icon(
        alreadySaved
            ? Icons.assignment_turned_in
            : Icons.assignment_turned_in_outlined,
        color: alreadySaved ? Colors.greenAccent : null,
        size: 35,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            saveCard.remove(w.toString());
          } else {
            saveCard.add(w.toString());
          }
        });
      },
    );
  }
}
