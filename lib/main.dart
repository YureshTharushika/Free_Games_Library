import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'Free Games Database'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static Future<List<Game>> getGames() async {
    const url = "https://www.freetogame.com/api/games";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List games = json.decode(response.body);
      return games.map<Game>(Game.fromJson).toList();
    } else {
      throw Exception();
    }
  }

  List<Game> gamesList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final displaylist = await getGames();
    setState(() {
      gamesList = displaylist;
    });
  }

  void updateList(String value) {
    setState(() {
      if (value.isEmpty) {
        init();
      } else {
        gamesList = gamesList
            .where((element) =>
                element.title.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: const Color(0xFF1f1545),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "Search for a Game",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              onChanged: (value) => updateList(value),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff302360),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Eg: Brawlhalla",
                hintStyle: TextStyle(color: Colors.grey),
                suffixIcon: Icon(Icons.search),
                suffixIconColor: Colors.purple.shade900,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: gamesList.length == 0
                  ? Center(
                      child: Text(
                        "No Results Found!",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      itemCount: gamesList.length,
                      itemBuilder: (context, index) {
                        final game = gamesList[index];
                        return ListTile(
                          contentPadding: EdgeInsets.all(6.0),
                          title: Text(
                            game.title,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            game.genre,
                            style: TextStyle(color: Colors.white60),
                          ),
                          trailing: Text(
                            game.releaseDate,
                            style: TextStyle(color: Colors.amber),
                          ),
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.network(game.thumbnail)),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }
}

// Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           children: [
//             TextField(
//               onTap: SearchResultPage(),
//               controller: controller,
//               decoration: InputDecoration(
//                 suffixIcon: const Icon(Icons.search),
//                 hintText: 'Game Title',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: BorderSide(color: Colors.grey),
//                 ),
//               ),
//               onChanged: searchGame,
//             ),
//             FutureBuilder<List<Game>>(
//               future: gamesFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   final games = snapshot.data!;
//                   return buildGames(games);
//                 } else {
//                   return const Text('No Games Data!');
//                 }
//               },
//             )
//           ],
//         ),
//       ),
