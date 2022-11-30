import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:free_games_library/themes.dart';
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
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

  static Future<List<Game>> getCategoryGames(String category) async {
    String url =
        "https://www.freetogame.com/api/games?category=${category.toLowerCase()}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List games = json.decode(response.body);
      return games.map<Game>(Game.fromJson).toList();
    } else {
      throw Exception();
    }
  }

  bool switchValue = false;

  List<Game> gamesList = [];

  List<String> categoryList = [
    'All',
    '2D',
    '3D',
    'Action',
    'Action-RPG',
    'Anime',
    'Battle-Royale',
    'Card',
    'Fantasy',
    'Fighting',
    'First-Person',
    'Flight',
    'Horror',
    'Low-Spec',
    'Martial-Arts',
    'Military',
    'MMO',
    'MMOFPS',
    'MMORPG',
    'MMORTS',
    'MMOTPS',
    'MOBA',
    'Open-World',
    'Permadeath',
    'Pixel',
    'PvE',
    'PvP',
    'Racing',
    'Sailing',
    'Sandbox',
    'Sci-Fi',
    'Shooter',
    'Side-Scroller',
    'Social',
    'Space',
    'Sports',
    'Strategy',
    'Superhero',
    'Survival',
    'Tank',
    'Third-Person',
    'Top-Down',
    'Tower-Defense',
    'Turn-Based',
    'Voxel',
    'Zombie'
  ];

  Color background = Themes().lightbrown;
  Color secondaryColor = Themes().lightgrey;
  Color mainText = Themes().darkyellow;
  Color secondaryText = Themes().lightyellow;

  void switchTheme() {
    if (switchValue == false) {
      background = Themes().lightbrown;
      secondaryColor = Themes().lightgrey;
      mainText = Themes().darkyellow;
      secondaryText = Themes().lightyellow;
    } else if (switchValue == true) {
      background = Themes().darkgreen;
      secondaryColor = Themes().green;
      mainText = Themes().lightgreen;
      secondaryText = Themes().limegreen;
    }
  }

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

  Future initSort(String value) async {
    final displaylist = await getCategoryGames(value);
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

  void categorySort(String value) {
    setState(() {
      if (value == "All") {
        init();
      } else {
        initSort(value);
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
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0.0,
        title: Text(
          "Free Games Library",
          style: TextStyle(
              color: mainText, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) => updateList(value),
              style: TextStyle(color: mainText),
              decoration: InputDecoration(
                filled: true,
                fillColor: secondaryColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Search...",
                hintStyle: TextStyle(color: mainText),
                suffixIcon: Icon(
                  Icons.search,
                  color: mainText,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 60,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: 46,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 5.0,
                    );
                  },
                  itemBuilder: (context, index) {
                    return buildCategoryCard(index);
                  }),
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
                            color: mainText,
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
                                color: mainText, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            game.genre,
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Text(
                            game.releaseDate,
                            style: TextStyle(color: secondaryColor),
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
      drawer: buildNavigationDrawer(context),
    );
  }

  Widget buildCategoryCard(int index) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () {
        categorySort(categoryList[index]);
      },
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(categoryList[index]),
        ),
      ),
    );
  }

  Widget buildNavigationDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      height: 200.0,
      color: background,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 70.0,
          ),
          Text(
            'FREE GAMES LIBRARY',
            style: TextStyle(color: mainText, fontSize: 26.0),
          ),
          const SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        runSpacing: 10.0,
        children: [
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: secondaryColor,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: mainText),
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) =>
                        const MyHomePage(title: 'Free Games Library'))),
          ),
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: secondaryColor,
            ),
            title: Text(
              'Dark Mode',
              style: TextStyle(color: mainText),
            ),
            trailing: buildThemeSwitch(),
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app_outlined,
              color: secondaryColor,
            ),
            title: Text(
              'Exit',
              style: TextStyle(color: mainText),
            ),
            onTap: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else {
                exit(0);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildThemeSwitch() {
    return Switch.adaptive(
      activeColor: background,
      activeTrackColor: secondaryColor,
      inactiveThumbColor: background,
      inactiveTrackColor: secondaryColor,
      value: switchValue,
      onChanged: (value) => setState(() {
        switchValue = value;
        switchTheme();
      }),
    );
  }
}
