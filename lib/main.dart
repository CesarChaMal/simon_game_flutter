import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(SimonGame());

class SimonGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<int> sequence = [];
  final List<int> userInput = [];
  final Random rng = Random();
  int currentIndex = 0;
  bool inputEnabled = false;
  int? activeButton;

  void startGame() {
    sequence.clear();
    userInput.clear();
    currentIndex = 0;
    addToSequence();
  }

  void addToSequence() {
    inputEnabled = false;
    userInput.clear();
    sequence.add(rng.nextInt(4));
    playSequence();
  }

  void playSequence() async {
    for (int i = 0; i < sequence.length; i++) {
      setState(() => activeButton = sequence[i]);
      await Future.delayed(Duration(milliseconds: 500));
      setState(() => activeButton = null);
      await Future.delayed(Duration(milliseconds: 300));
    }
    inputEnabled = true;
  }

  void handleUserInput(int colorIndex) {
    if (!inputEnabled) return;
    setState(() => activeButton = colorIndex);
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() => activeButton = null);
    });

    userInput.add(colorIndex);
    if (userInput[userInput.length - 1] != sequence[userInput.length - 1]) {
      showGameOver();
      return;
    }

    if (userInput.length == sequence.length) {
      currentIndex++;
      Future.delayed(Duration(milliseconds: 500), addToSequence);
    }
  }

  void showGameOver() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Game Over"),
        content: Text("You reached level ${sequence.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              startGame();
            },
            child: Text("Restart"),
          ),
        ],
      ),
    );
    inputEnabled = false;
  }

  Widget buildColorButton(int index, Color color) {
    return GestureDetector(
      onTap: () => handleUserInput(index),
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: activeButton == index ? color.withOpacity(0.5) : color,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 150,
        width: 150,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Simón Says")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              buildColorButton(0, Colors.red),
              buildColorButton(1, Colors.yellow),
              buildColorButton(2, Colors.green),
              buildColorButton(3, Colors.blue),
            ],
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: startGame,
            child: Text("Jugar"),
          )
        ],
      ),
    );
  }
}
