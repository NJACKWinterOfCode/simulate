import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'data/simulations.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simulate/src/custom_items/chemistry_page.dart';
import 'package:simulate/src/custom_items/home_page.dart';
import 'package:simulate/src/custom_items/mathematics_page.dart';
import 'package:simulate/src/custom_items/physics_page.dart';
import 'package:simulate/src/custom_items/algorithms_page.dart';
import 'package:simulate/src/custom_items/simulation_card.dart';

class Home extends StatefulWidget {
  final List<Widget> _categoryTabs = [
    Tab(
      child: Text('Home'),
    ),
    Tab(
      child: Text('Physics'),
    ),
    Tab(
      child: Text('Algorithms'),
    ),
    Tab(
      child: Text('Mathematics'),
    ),
    Tab(
      child: Text('Chemistry'),
    ),
  ];
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _categoryController;

  @override
  void initState() {
    super.initState();
    _categoryController = TabController(
      vsync: this,
      length: 5,
    );
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Simulate',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Ubuntu',
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SimulationSearch(),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _categoryController,
          isScrollable: true,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black.withOpacity(0.3),
          indicatorColor: Colors.black,
          tabs: widget._categoryTabs,
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Image.asset(
                'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png',
                height: MediaQuery.of(context).size.height / 18,
                width: MediaQuery.of(context).size.height / 18 * 3.0881,
              ),
            ),
            customListTile(context, "Rate the app", Icon(Icons.star_border)),
            customListTile(context, "About", Icon(Icons.info_outline)),
            Spacer(),
            customListTile(context, "Exit", Icon(Icons.exit_to_app)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _categoryController,
        children: <Widget>[
          HomePage(),
          PhysicsPage(),
          AlgorithmsPage(),
          MathematicsPage(),
          ChemistryPage(),
        ],
      ),
    );
  }

  Widget customListTile(BuildContext context, String text, Icon icon) {
    return ListTile(
      trailing: Icon(icon.icon),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Ubuntu',
        ),
      ),
      onTap: () async {
        if (text == "Exit")
          exit(0);
        else if (text == "About") {
          Navigator.pop(context);
          final url = 'https://github.com/cod-ed/simulate';
          if (await canLaunch(url))
            await launch(url);
          else
            throw 'Could not launch';
        }
      },
    );
  }
}

class SimulationSearch extends SearchDelegate<SimulationCard> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final appState = Provider.of<Simulations>(context);
    return (query != '')
        ? (appState.searchSims(query).length != 0)
            ? GridView.count(
                crossAxisCount: (MediaQuery.of(context).size.width < 600)
                    ? 2
                    : (MediaQuery.of(context).size.width / 200).floor(),
                children: appState.searchSims(query),
              )
            : Container(
                child: Center(
                  child: Text(
                    "Sorry, couldn't find a simulation",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                ),
              )
        : Container(
            child: Center(
              child: Text(
                'Search for Simulations',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 30,
                  fontFamily: 'Ubuntu',
                ),
              ),
            ),
          );
  }
}
