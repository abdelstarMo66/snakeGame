import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  List<int> snakePosition = [43, 63, 83, 103];
  int numOfSquares = 760;
  static var randomNumber = Random();
  int food = randomNumber.nextInt(700);
  var speed = 300;
  bool playing = false;
  var direction = 'down';
  bool x1 = true;
  bool x2 = false;
  bool x3 = false;
  bool endGame = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      "assets/snake.png",
                      opacity: const AlwaysStoppedAnimation(.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: GridView.builder(
                      itemCount: numOfSquares,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 20,
                      ),
                      itemBuilder: (context, index) {
                        if (snakePosition.contains(index)) {
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.all(2.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                        if (index == food) {
                          return Container(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0.0),
                              child: const Center(
                                child: Icon(
                                  Icons.fastfood_sharp,
                                  size: 20.0,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          !playing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: x1 ? Colors.green : Colors.transparent,
                      ),
                      margin: const EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            x1 = true;
                            x2 = false;
                            x3 = false;
                            speed = 300;
                          });
                        },
                        child: const Text(
                          "x1",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: x2 ? Colors.green : Colors.transparent,
                      ),
                      margin: const EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            x2 = true;
                            x1 = false;
                            x3 = false;
                            speed = 200;
                          });
                        },
                        child: const Text(
                          "x2",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: x3 ? Colors.green : Colors.transparent,
                      ),
                      margin: const EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            x3 = true;
                            x2 = false;
                            x1 = false;
                            speed = 100;
                          });
                        },
                        child: const Text(
                          "x3",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 0.5,
                      height: 30.0,
                      color: Colors.grey,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        startGame();
                      },
                      child: Row(
                        children: const [
                          Text(
                            "Start",
                            style: TextStyle(color: Colors.amber),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.play_arrow,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(
                  height: 50.0,
                  decoration:const BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50.0),
                      topLeft: Radius.circular(50.0),
                    ),
                  ),
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          endGame = true;
                        });
                      },
                      child: Text(
                        "End the Game and show result",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Colors.white,
                          fontSize: 15.0,
                            ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  startGame() {
    setState(() {
      playing = true;
    });
    endGame = false;
    snakePosition = [43, 63, 83, 103];
    var duration = Duration(milliseconds: speed);
    Timer.periodic(duration, (timer) {
      updateSnake();
      if (gameOver() || endGame) {
        timer.cancel();
        showGameOverDialog();
        playing = false;
        x1 = true;
        x2 = false;
        x3 = false;
      }
    });
  }

  gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2) {
          setState(() {
            playing = false;
          });
          return true;
        }
      }
    }
    return false;
  }

  showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(child: Text("Game Over")),
        content: Text(
          "your score is ${snakePosition.length}",
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              startGame();
              Navigator.of(context).pop(true);
            },
            child: const Text("play Again",style: TextStyle(color: Colors.amber,),),
          ),
        ],
      ),
    );
  }

  generateNewFood() {
    food = randomNumber.nextInt(700);
  }

  updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > 740) {
            snakePosition.add(snakePosition.last + 20 - 760);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;

        case 'up':
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last - 20 + 760);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;

        case 'left':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;

        case 'right':
          if ((snakePosition.last + 1) % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;

        default:
      }

      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }
}
