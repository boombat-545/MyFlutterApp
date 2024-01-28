import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Splash Screen'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordSearchScreen(),
                  ),
                );
              },
              child: Text('Enter the App'),
            ),
          ],
        ),
      ),
    );
  }
}

class WordSearchScreen extends StatefulWidget {
  @override
  _WordSearchScreenState createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  late List<List<String>> grid;
  late int rows;
  late int columns;
  final TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    resetSetup();
  }

  void resetSetup() {
    setState(() {
      grid = List.generate(20, (index) => List.generate(20, (index) => ''));
      rows = 0;
      columns = 0;
    });
  }

  void createGrid() {
    final alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        grid[i][j] = alphabet[random.nextInt(alphabet.length)];
      }
    }
  }

  bool searchWord(String word) {
    final m = rows;
    final n = columns;

    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (_wordInDirection(word, i, j, 0, 1) || // East
            _wordInDirection(word, i, j, 1, 0) || // South
            _wordInDirection(word, i, j, 1, 1)) { // South-East
          _highlightWord(i, j, 0, 1, word.length);
          return true;
        }
      }
    }

    return false;
  }

  bool _wordInDirection(String word, int startI, int startJ, int di, int dj) {
    final m = rows;
    final n = columns;

    for (int k = 0; k < word.length; k++) {
      int i = startI + k * di;
      int j = startJ + k * dj;
      if (i < 0 || i >= m || j < 0 || j >= n || grid[i][j] != word[k]) {
        return false;
      }
    }

    return true;
  }

  void _highlightWord(int startI, int startJ, int di, int dj, int length) {
    for (int k = 0; k < length; k++) {
      int i = startI + k * di;
      int j = startJ + k * dj;
      grid[i][j] = grid[i][j].toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Search App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Step 2: Enter the number of rows and columns for a 20x20 grid:'),
              Row(
                children: [
                  Text('Rows:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          rows = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Columns:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          columns = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  createGrid();
                  setState(() {});
                },
                child: Text('Step 4: Create Grid'),
              ),
              SizedBox(height: 20),
              Text('Step 5: Display the Grid:'),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 20,
                ),
                itemBuilder: (context, index) {
                  final row = index ~/ 20;
                  final col = index % 20;
                  return Container(
                    color: grid[row][col].toLowerCase() == grid[row][col]
                        ? Colors.yellow
                        : Colors.white,
                    child: Center(
                      child: Text(grid[row][col]),
                    ),
                  );
                },
                itemCount: 20 * 20,
              ),
              SizedBox(height: 20),
              Text('Step 7: Enter the text to search:'),
              TextField(
                controller: searchTextController,
                decoration: InputDecoration(labelText: 'Enter text to search'),
              ),
              ElevatedButton(
                onPressed: () {
                  final searchText = searchTextController.text.toUpperCase();
                  if (searchText.isNotEmpty) {
                    final found = searchWord(searchText);
                    if (found) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Word found!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Word not found in the grid.'),
                        ),
                      );
                    }
                  }
                },
                child: Text('Step 8: Search Word'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: resetSetup,
                child: Text('Reset Setup (Step 2)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
