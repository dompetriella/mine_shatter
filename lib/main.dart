import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'MineSweep'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    int rowCount = 10;
    int totalSquares = rowCount * rowCount;

    int mines = (totalSquares * .20).toInt();

    bool isLeft(int index) {
      if (index % rowCount == 0) return true;
      return false;
    }

    bool isRight(int index) {
      if ((index+1) % rowCount == 0) return true;
      return false;
    }

    bool isTop(int index) {
      if (index < rowCount) return true;
      return false;
    }

    bool isBottom(int index) {
      if (index >= totalSquares - rowCount) return true;
      return false;
    }

    int addMine(Panel panel) {
      if (panel.hasMine) return 1;
      return 0;
    }

    List<Panel> createBoard() {
      List<Panel> gameBoard = [];
      int minesTotal = mines;
      for (int i = 0; i < totalSquares; i++) {
        gameBoard.add(Panel(
          hasMine: minesTotal < 1 ? false : true
          ),
        );
        if (minesTotal > 0) minesTotal--;
      }
      gameBoard.shuffle();

      int i = 0;
      for (var element in gameBoard) {

        element.index = i;

        if (!element.hasMine) {
          // add nearby left of current panel
          if (!isLeft(i)) {
            element.nearbyMines += addMine(gameBoard[i-1]);
          }

          // add one panel above
          if (!isTop(i)) {
            element.nearbyMines += addMine(gameBoard[i-rowCount]);
            // top left
            if (!isLeft(i)) {
            element.nearbyMines += addMine(gameBoard[(i-rowCount)-1]);
            }
            // top right
            if (!isRight(i)) {
              element.nearbyMines += addMine(gameBoard[(i-rowCount)+1]);
            }
          }
          
          // add one panel to the right
          if (!isRight(i)) {
            element.nearbyMines += addMine(gameBoard[i+1]);
          }

          // add one panel below
          if (!isBottom(i)) {
            element.nearbyMines += addMine(gameBoard[i+rowCount]);
            if (!isRight(i)) {
              element.nearbyMines += addMine(gameBoard[(i+rowCount)+1]);
            }
            if (!isLeft(i)) {
              element.nearbyMines += addMine(gameBoard[(i+rowCount)-1]);
            }
          }
        }
        
        i++;
      }

      return gameBoard;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('MineSweep'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          height: 400,
          child: GridView.count(
            crossAxisCount: rowCount,
            children: createBoard()
          ),
        ),
      ),
    );
  }
}

class Panel extends StatefulWidget {
  bool hasMine;

  int index = 0;
  bool isClicked = false;
  bool isFlagged = false;
  int nearbyMines = 0;

  Panel({
    Key? key,
    required this.hasMine
  }) : super(key: key);

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.5),
      child: GestureDetector(
        onTap: () {
          print(widget.index);
          print(widget.nearbyMines);
        },
        child: Container(
          color: widget.hasMine? Colors.red : Colors.green,
          child: Center(
            child: Text(
              widget.nearbyMines == 0? '' : widget.nearbyMines.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
