import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/app_bar.dart';
import 'package:flutter_2048/dot_field.dart';
import 'package:flutter_2048/game_over.dart';
import 'package:flutter_2048/game_theme_extension.dart';
import 'package:flutter_2048/game_tile.dart';
import 'package:flutter_2048/game_won.dart';
import 'package:flutter_2048/matrix_rain.dart';
import 'package:flutter_2048/onboarding_page.dart';
import 'package:flutter_2048/score_card.dart';
import 'package:flutter_2048/theme_controller.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePage extends StatefulWidget {
  final ThemeController themeController;
  const GamePage({super.key, required this.themeController});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Logger logger = Logger();
  late List<List<int>> board;
  Offset? _startDragOffset;
  bool gameOver = false;
  bool gameWon = false;
  bool isLoading = true;

  int score = 0;
  int highScore = 0;

  void _addScore(int points) {
    score += points;
    if (score > highScore) {
      highScore = score;
    }
  }

  void _showTutorial() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: true,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) {
            return OnboardingPage(
              themeController: widget.themeController,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        ),
      );
    });
  }

  Point<int>? lastAddedTile;

  Future<void> _loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final boardString = prefs.getString('board');
    final gameOverState = prefs.getBool('gameOver') ?? false;
    final savedHighScore = prefs.getInt('highScore') ?? 0;
    final savedScore = prefs.getInt('score') ?? 0;

    if (boardString != null) {
      final boardList = List<List<int>>.from(
        json.decode(boardString).map((e) => List<int>.from(e)),
      );
      setState(() {
        board = boardList;
        gameOver = gameOverState;
        highScore = savedHighScore;
        score = savedScore;
        isLoading = false;
      });
    } else {
      _initBoard();
    }
  }

  Future<void> _saveGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final boardString = json.encode(board);
    await prefs.setString('board', boardString);
    await prefs.setBool('gameOver', gameOver);
    await prefs.setInt('score', score);
    if (score > highScore) {
      highScore = score;
    }
    await prefs.setInt('highScore', highScore);
  }

  @override
  void initState() {
    super.initState();
    _loadGameState();
  }

  void _initBoard() {
    board = List.generate(4, (_) => List.filled(4, 0));
    _addRandomTile();
    _addRandomTile();
    _saveGameState();
    _loadGameState();
  }

  void _addRandomTile() {
    final empty = <Point<int>>[];
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if (board[r][c] == 0) empty.add(Point(r, c));
      }
    }
    if (empty.isNotEmpty) {
      final point = empty[Random().nextInt(empty.length)];
      final newValue = Random().nextInt(10) < 9 ? 2 : 4;
      board[point.x][point.y] = newValue;
      lastAddedTile = point;

      // ✅ Check if 2048 tile was just added
      if (!gameWon && newValue == 2048) {
        setState(() {
          gameWon = true;
        });
      }
    }
  }

  List<List<int>> _copyBoard(List<List<int>> original) {
    return original.map((row) => List<int>.from(row)).toList();
  }

  bool _boardsEqual(List<List<int>> a, List<List<int>> b) {
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if (a[r][c] != b[r][c]) return false;
      }
    }
    return true;
  }

  bool _isGameOver() {
    // If any cell is zero, game is not over
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if (board[r][c] == 0) return false;
      }
    }

    // Check horizontal merges
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 3; c++) {
        if (board[r][c] == board[r][c + 1]) return false;
      }
    }

    // Check vertical merges
    for (int c = 0; c < 4; c++) {
      for (int r = 0; r < 3; r++) {
        if (board[r][c] == board[r + 1][c]) return false;
      }
    }
    _saveGameState(); // Save game state when game is over
    return true;
  }

  void _moveLeft() {
    final oldBoard = _copyBoard(board);
    for (int r = 0; r < 4; r++) {
      List<int> newRow = board[r].where((val) => val != 0).toList();
      for (int i = 0; i < newRow.length - 1; i++) {
        if (newRow[i] == newRow[i + 1]) {
          newRow[i] *= 2;
          _addScore(newRow[i]);
          newRow[i + 1] = 0;
        }
      }
      newRow = newRow.where((val) => val != 0).toList();
      while (newRow.length < 4) {
        newRow.add(0);
      }
      board[r] = newRow;
    }

    if (!_boardsEqual(oldBoard, board)) {
      _addRandomTile();
      setState(() {});
      _saveGameState(); // Save game state after a move
      if (_isGameOver()) {
        gameOver = true;
      }
    }
  }

  void _moveRight() {
    final oldBoard = _copyBoard(board);
    for (int r = 0; r < 4; r++) {
      List<int> newRow = board[r].reversed.where((val) => val != 0).toList();
      for (int i = 0; i < newRow.length - 1; i++) {
        if (newRow[i] == newRow[i + 1]) {
          newRow[i] *= 2;
          _addScore(newRow[i]);
          newRow[i + 1] = 0;
        }
      }
      newRow = newRow.where((val) => val != 0).toList();
      while (newRow.length < 4) {
        newRow.add(0);
      }
      board[r] = newRow.reversed.toList();
    }
    if (!_boardsEqual(oldBoard, board)) {
      _addRandomTile();
      setState(() {});
      _saveGameState(); // Save game state after a move
      if (_isGameOver()) {
        gameOver = true;
      }
    }
  }

  void _moveUp() {
    final oldBoard = _copyBoard(board);
    for (int c = 0; c < 4; c++) {
      List<int> col = [];
      for (int r = 0; r < 4; r++) {
        if (board[r][c] != 0) col.add(board[r][c]);
      }
      for (int i = 0; i < col.length - 1; i++) {
        if (col[i] == col[i + 1]) {
          col[i] *= 2;
          _addScore(col[i]);
          col[i + 1] = 0;
        }
      }
      col = col.where((val) => val != 0).toList();
      while (col.length < 4) {
        col.add(0);
      }
      for (int r = 0; r < 4; r++) {
        board[r][c] = col[r];
      }
    }
    if (!_boardsEqual(oldBoard, board)) {
      _addRandomTile();
      setState(() {});
      _saveGameState(); // Save game state after a move
      if (_isGameOver()) {
        gameOver = true;
      }
    }
  }

  void _moveDown() {
    final oldBoard = _copyBoard(board);
    for (int c = 0; c < 4; c++) {
      List<int> col = [];
      for (int r = 3; r >= 0; r--) {
        if (board[r][c] != 0) col.add(board[r][c]);
      }
      for (int i = 0; i < col.length - 1; i++) {
        if (col[i] == col[i + 1]) {
          col[i] *= 2;
          _addScore(col[i]);
          col[i + 1] = 0;
        }
      }
      col = col.where((val) => val != 0).toList();
      while (col.length < 4) {
        col.add(0);
      }
      for (int r = 0; r < 4; r++) {
        board[3 - r][c] = col[r];
      }
    }
    if (!_boardsEqual(oldBoard, board)) {
      _addRandomTile();
      setState(() {});
      _saveGameState(); // Save game state after a move
      if (_isGameOver()) {
        gameOver = true;
      }
    }
  }

  Color _getTileColor(int value) {
    final extension = Theme.of(context).extension<GameThemeExtension>();
    return extension?.tileColors[value] ??
        Theme.of(context).extension<GameThemeExtension>()?.defaultTileColor ??
        Colors.grey;
  }

  double get tileSize {
    return MediaQuery.of(context).size.width / 4 - 16;
  }

  @override
  Widget build(BuildContext context) {
    final themeExtension = Theme.of(context).extension<GameThemeExtension>();
    final bool isImage = themeExtension?.isImage ?? false;
    final String? imagePath = themeExtension?.imagePath;
    final bool hasDotField = themeExtension?.hasDotField ?? false;
    final bool hasMatrixBg = themeExtension?.hasMatrixBg ?? false;
    final double tileSize = this.tileSize;

    final screenWidth = MediaQuery.of(context).size.width;
    final Widget gameContent = Padding(
      padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenWidth * 0.04, screenWidth * 0.04, 0),
      child: Column(
        children: [
          ScoreBoard(score: score, highScore: highScore),
          SizedBox(height: screenWidth * 0.04),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 16,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: tileSize,
                crossAxisCount: 4,
                crossAxisSpacing: screenWidth * 0.02,
                mainAxisSpacing: screenWidth * 0.02,
                childAspectRatio: 1,
              ),
              itemBuilder: (_, index) {
                int row = index ~/ 4;
                int col = index % 4;
                int value = board[row][col];

                return GameTile(
                  value: value,
                  index: index,
                  getTileColor: _getTileColor,
                );
              },
            ),
          ),
        ],
      ),
    );

    final Widget gameStack = Stack(
      children: [
        gameContent,
        if (gameWon) GameWinOverlay(visible: gameWon),
        if (gameOver) GameOverOverlay(visible: gameOver),
      ],
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Exit Game?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            content: Text(
              'Your progress is saved. Are you sure you want to exit?',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.fontFamily,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(
                  'Exit',
                  style: TextStyle(
                    fontFamily: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.fontFamily,
                  ),
                ),
              ),
            ],
          ),
        );
        if (shouldExit == true && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
      appBar: GameAppBar(
        title: '2048 Game',
        themeController: widget.themeController,
        onRestart: () {
          setState(() {
            _initBoard();
            gameOver = false;
            gameWon = false;
          });
          _showTutorial();
        },
      ),
      body: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent && !gameOver && !gameWon) {
            switch (event.logicalKey.keyLabel) {
              case 'Arrow Left':
                _moveLeft();
                break;
              case 'Arrow Right':
                _moveRight();
                break;
              case 'Arrow Up':
                _moveUp();
                break;
              case 'Arrow Down':
                _moveDown();
                break;
            }
          }
          return KeyEventResult.handled;
        },
        child: GestureDetector(
          onPanStart: (details) {
            if (gameOver || gameWon) return;
            _startDragOffset = details.globalPosition;
          },
          onPanEnd: (details) {
            if (gameOver || gameWon) return;
            if (_startDragOffset == null) return;

            final endPosition = details.globalPosition;
            final dx = endPosition.dx - _startDragOffset!.dx;
            final dy = endPosition.dy - _startDragOffset!.dy;

            final minSwipeDistance = 30.0;
            if (dx.abs() < minSwipeDistance && dy.abs() < minSwipeDistance) {
              _startDragOffset = null;
              return;
            }

            if (dx.abs() > dy.abs()) {
              dx > 0 ? _moveRight() : _moveLeft();
            } else {
              dy > 0 ? _moveDown() : _moveUp();
            }

            _startDragOffset = null;
          },
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : isImage && imagePath != null
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        gameStack,
                      ],
                    )
                  : hasMatrixBg
                      ? Stack(
                          children: [
                            Positioned.fill(
                              child: MatrixRain(
                                baseColor: const Color(0xFF39D353),
                              ),
                            ),
                            gameStack,
                          ],
                        )
                      : hasDotField
                          ? Stack(
                              children: [
                                Positioned.fill(
                                  child: DotField(
                                    sparkle: true,
                                    glow: true,
                                    gradientFrom:
                                        themeExtension?.dotFieldGradientFrom ??
                                            const Color.fromRGBO(30, 100, 220, 0.35),
                                    gradientTo:
                                        themeExtension?.dotFieldGradientTo ??
                                            const Color.fromRGBO(100, 160, 230, 0.25),
                                  ),
                                ),
                                gameStack,
                              ],
                            )
                          : gameStack,
        ),
      ),
    ), // Scaffold
    ); // PopScope
  }
}
