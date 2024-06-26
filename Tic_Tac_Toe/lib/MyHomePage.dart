import 'package:flutter/material.dart';
import 'package:tic_tac_toe/enterPlayer.dart';

class MyHomePage extends StatefulWidget {
  final String player1;
  final String player2;
  const MyHomePage({Key? key, required this.player1, required this.player2}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  var grid = [' ',' ',' ',' ',' ',' ',' ',' ',' ',];

  var currentPlayer = 'X';
  void mark_XO(i) {
    if(grid[i] == ' ') {
      setState(() {
        grid[i] = currentPlayer;
        currentPlayer == 'X'
        ? currentPlayer = 'O'
        : currentPlayer = 'X';
      });
      findWinner(grid[i]);
    }
  }

  void reset() {
    setState(() {
      grid = [' ',' ',' ',' ',' ',' ',' ',' ',' ',];
    });
  }

  bool checkWinner(i1,i2,i3,currentPlayer) {
    if(grid[i1] == currentPlayer && grid[i2] == currentPlayer && grid[i3] == currentPlayer){
      return true;
    }
    else{
      return false;
    }
  }

  void findWinner(currentPlayer) {
    if(checkWinner(0,1,2,currentPlayer) || checkWinner(3,4,5,currentPlayer) || checkWinner(6,7,8,currentPlayer) ||
    checkWinner(0,3,6,currentPlayer) || checkWinner(1,4,7,currentPlayer) || checkWinner(2,5,8,currentPlayer) ||
    checkWinner(0,4,8,currentPlayer) || checkWinner(2,4,6,currentPlayer)
    ) {
      String player;
      if(currentPlayer == 'X') {
        player = widget.player1;
      }
      else{ player = widget.player2; }
      showMessageDialog(context, 'Congratulations $player won the game:');
    } else if (grid.every((element) => element != ' ')) {
      // Check for a draw
      showMessageDialog(context, 'oops! It\'s a draw game..');
    }
  }


  void showMessageDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false ,
            child: AlertDialog(
              title: const Text('Tic Tac Toe', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14),),
              content: Text(message, style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();  // Close the dialog
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const enterPlayer()), (route) => false);
                  },
                  child: const Text('Exit'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    reset(); // Close the dialog
                  },
                  child: const Text('Restart'),
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentPlayer == 'X'
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward, color: Colors.orange),
                      Text("${widget.player1} [X]", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)),
                    ],
                  )
                  : Text("${widget.player1} [X]", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10,
                  ),
                  itemCount: grid.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.orange,
                      child: InkWell(
                        focusColor: Colors.lightGreen,
                        hoverColor: Colors.lightGreen,
                        highlightColor: Colors.lightGreen,
                        splashColor: Colors.lightGreen ,
                        onTap: () => mark_XO(index),
                        child: Center(
                          child: Text(grid[index], style: TextStyle(fontSize:40, color: Colors.deepPurple)),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                currentPlayer == 'O'
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward, color: Colors.orange),
                      Text("${widget.player2} [O]", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)),
                    ],
                  )
                  : Text("${widget.player2} [O]", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                    child: ElevatedButton(
                        onPressed: () { reset(); },
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [Icon(Icons.refresh_rounded), Text('Restart')],)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
