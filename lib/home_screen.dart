import 'package:flutter/material.dart';
import 'package:tic_tac/game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation==Orientation.portrait? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ...firstBlock(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _expandedGrid(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ...lastBlock(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            ],
          ),
        ) :
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...firstBlock(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        ...lastBlock(),
                      ],
                    ),
                  ),
                  _expandedGrid(),
                ],
              ),
            )
      ),
    );
  }

  List<Widget> firstBlock() => [
    SwitchListTile.adaptive(
      value: isSwitched,
      onChanged: (bool newvalue) {
        setState(() {
          isSwitched = newvalue;
        });
      },
      title: Text(
        'Turn on/off two player',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
    Text(
      'it\'s $activePlayer turn'.toUpperCase(),
      style: TextStyle(
        color: Colors.white,
        fontSize: 50,
      ),
      textAlign: TextAlign.center,
    ),
  ];
  Expanded _expandedGrid () => Expanded(
    child: GridView.count(
      padding: EdgeInsets.all(16),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 1.0,
      crossAxisCount: 3,
      children: List.generate(
          9,
              (index) => InkWell(
            onTap: gameOver?null:()=>_onTap(index),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).shadowColor,
              ),
              child: Center(
                child: Text(
                  Player.playerX.contains(index) ? 'X' : (Player.playerO.contains(index) ? 'O' : ''),
                  style: TextStyle(
                    color: Player.playerX.contains(index) ? Colors.blue : Colors.pink ,
                    fontSize: 50,
                  ),
                ),
              ),
            ),
          )),
    ),
  );
  List<Widget> lastBlock() => [
    Text(
      result,
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
      ),
      textAlign: TextAlign.center,
    ),
    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
    MaterialButton(
      onPressed: () {
        setState(() {
          activePlayer = 'X';
          gameOver = false;
          turn = 0;
          result = '';
          Player.playerX = [];
          Player.playerO = [];
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.replay),
          SizedBox(
            width: 7,
          ),
          Text('Repeat the game'),
        ],
      ),
      color: Theme.of(context).splashColor,
    ),
  ];
  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) && (Player.playerO.isEmpty || !Player.playerO.contains(index))){
      game.playGame(index,activePlayer);
      updateState();
      if (!isSwitched && !gameOver && turn != 9){
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }
  void updateState(){
    setState(() {
      activePlayer = activePlayer=='X'?'O':'X';
      turn++;
    });
    String winnerPlayer = game.checkWinner();
    if(winnerPlayer != ''){
      result = '$winnerPlayer is the winner';
      gameOver = true;
    }else{
      if (!gameOver && turn == 9){
        result = 'it\'s Draw!';
      }
    }

  }
}
