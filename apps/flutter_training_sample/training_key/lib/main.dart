import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: PositionedTiles(),
  ));
}

class PositionedTiles extends StatefulWidget {
  const PositionedTiles({super.key});

  @override
  State<PositionedTiles> createState() => _PositionedTilesState();
}

class _PositionedTilesState extends State<PositionedTiles> {
  List<Widget> tiles = [
    const StatelessColorfulTile(),
    const StatelessColorfulTile(),
  ];

  @override
  void initState() {
    super.initState();
    tiles = [
      StatelessColorfulTile(key: UniqueKey()),
      StatelessColorfulTile(key: UniqueKey()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tiles,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: swrapTiles,
        child: const Icon(Icons.sentiment_very_satisfied),
      ),
    );
  }

  swrapTiles() {
    setState(() {
      tiles.insert(1, tiles.removeAt(0));
    });
  }
}

class StatelessColorfulTile extends StatefulWidget {
  const StatelessColorfulTile({super.key});

  @override
  State<StatelessColorfulTile> createState() => _StatelessColorfulTileState();
}

class _StatelessColorfulTileState extends State<StatelessColorfulTile> {
  final Random _random = Random();

  Color _color = Colors.black;

  @override
  void initState() {
    super.initState();
    _color = Color.fromARGB(
      //or with fromRGBO with fourth arg as _random.nextDouble(),
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
      child: const Padding(padding: EdgeInsets.all(70)),
    );
  }
}
