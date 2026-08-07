import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_2048/game_logic.dart';
import 'package:flutter_2048/game_theme_extension.dart';
import 'package:flutter_2048/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  final ThemeController themeController;
  const OnboardingPage({super.key, required this.themeController});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// Returns black or white depending on which contrasts better with [bg].
  Color _contrastColor(Color bg) =>
      bg.computeLuminance() > 0.35 ? Colors.black : Colors.white;

  Color _getTileColor(int value) {
    final extension = Theme.of(context).extension<GameThemeExtension>();
    return extension?.tileColors[value] ??
        extension?.defaultTileColor ??
        Colors.grey;
  }

  Color _getTileTextColor(int value) {
    final extension = Theme.of(context).extension<GameThemeExtension>();
    final custom = extension?.tileTextColor[value];
    if (custom != null) return custom;
    final tileColor = _getTileColor(value);
    return tileColor.computeLuminance() > 0.3
        ? Theme.of(context).primaryColorDark
        : Theme.of(context).primaryColorLight;
  }

  void _onSkip() => _complete();
  void _onNext() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  Future<void> _complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) =>
          GamePage(themeController: widget.themeController),
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 300),
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _complete();
      },
      child: Scaffold(
        backgroundColor: scaffoldBg,
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _onSkip,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  children: [
                    _SwipeToMovePage(
                      getTileColor: _getTileColor,
                      getTileTextColor: _getTileTextColor,
                    ),
                    _MergeTilesPage(
                      getTileColor: _getTileColor,
                      getTileTextColor: _getTileTextColor,
                    ),
                    _NewTilePage(
                      getTileColor: _getTileColor,
                      getTileTextColor: _getTileTextColor,
                    ),
                    _WinTipsPage(
                      getTileColor: _getTileColor,
                      getTileTextColor: _getTileTextColor,
                      onPlay: _onNext,
                    ),
                  ],
                ),
              ),
              _buildPageIndicator(isDark),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentPage == 3
                          ? _getTileColor(2048)
                          : Theme.of(context).primaryColor,
                      foregroundColor: _currentPage == 3
                          ? _getTileTextColor(2048)
                          : _contrastColor(Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: _currentPage == 3
                          ? _getTileColor(2048).withOpacity(0.5)
                          : Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                    child: Text(
                      _currentPage == 3 ? "Let's Play" : 'Next',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        // Use the theme's font family
                        fontFamily: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? Theme.of(context).primaryColor
                : (isDark ? Colors.white24 : Colors.black26),
          ),
        );
      }),
    );
  }
}

// ─── Tile widget used in all demo boards ─────────────────────────────────────

class _DemoTile extends StatelessWidget {
  final int value;
  final Color tileColor;
  final Color textColor;

  const _DemoTile({
    required this.value,
    required this.tileColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(8),
      color: tileColor,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: value > 250
              ? [
                  BoxShadow(
                    color: tileColor.withOpacity(0.7),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: value != 0
            ? Text(
                '$value',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      fontSize: value >= 1000
                          ? 14
                          : value >= 100
                              ? 18
                              : null,
                    ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

// ─── Reusable animated board grid ────────────────────────────────────────────

class _DemoBoard extends StatelessWidget {
  final List<List<int>> grid;
  final Color Function(int) getTileColor;
  final Color Function(int) getTileTextColor;

  const _DemoBoard({
    required this.grid,
    required this.getTileColor,
    required this.getTileTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : MediaQuery.of(context).size.width;

      // Board fills available width minus outer padding of parent (32*2=64)
      // Use a fixed gap; derive tileSize from it precisely:
      // boardSize = gap + 4*(tileSize + gap) = 5*gap + 4*tileSize
      // → tileSize = (boardSize - 5*gap) / 4
      const double gap = 6.0;
      const double boardPadding = 8.0;
      final boardSize = (availableWidth - 64).clamp(120.0, 280.0);
      final innerSize = boardSize - boardPadding * 2;
      final tileSize = (innerSize - gap * 5) / 4; // 5 gaps: before each tile + after last

      return Container(
        width: boardSize,
        height: boardSize,
        padding: const EdgeInsets.all(boardPadding),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .extension<GameThemeExtension>()
              ?.tileColors[0]
              ?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: grid.map((row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: gap),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: row.map((value) {
                  return Padding(
                    padding: const EdgeInsets.only(left: gap),
                    child: SizedBox(
                      width: tileSize,
                      height: tileSize,
                      child: _DemoTile(
                        value: value,
                        tileColor: getTileColor(value),
                        textColor: getTileTextColor(value),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}

// ─── Page 1: Swipe to Move ──────────────────────────────────────────────────

class _SwipeToMovePage extends StatefulWidget {
  final Color Function(int) getTileColor;
  final Color Function(int) getTileTextColor;

  const _SwipeToMovePage({
    required this.getTileColor,
    required this.getTileTextColor,
  });

  @override
  State<_SwipeToMovePage> createState() => _SwipeToMovePageState();
}

class _SwipeToMovePageState extends State<_SwipeToMovePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _animationStep = 0;

  final List<List<int>> _startGrid = [
    [0, 0, 0, 0],
    [0, 2, 0, 0],
    [0, 0, 4, 0],
    [0, 0, 0, 2],
  ];

  final List<List<int>> _endGrid = [
    [0, 0, 0, 0],
    [2, 0, 0, 0],
    [4, 0, 0, 0],
    [2, 0, 0, 0],
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _startLoop();
  }

  Future<void> _startLoop() async {
    while (mounted) {
      // Show start state
      setState(() => _animationStep = 0);
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;

      // Animate to end state
      setState(() => _animationStep = 1);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;

      // Show arrow direction
      setState(() => _animationStep = 2);
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;

      // Reset
      setState(() => _animationStep = 0);
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentGrid = _animationStep >= 1 ? _endGrid : _startGrid;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: KeyedSubtree(
              key: ValueKey(_animationStep),
              child: _DemoBoard(
                grid: currentGrid,
                getTileColor: widget.getTileColor,
                getTileTextColor: widget.getTileTextColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Animated swipe arrow
          AnimatedOpacity(
            opacity: _animationStep == 2 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Swipe anywhere to move every tile.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'All tiles slide in the direction of your swipe.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 15,
                ),
          ),
        ],
      ),
    );
  }
}

// ─── Page 2: Merge Tiles ────────────────────────────────────────────────────

class _MergeTilesPage extends StatefulWidget {
  final Color Function(int) getTileColor;
  final Color Function(int) getTileTextColor;

  const _MergeTilesPage({
    required this.getTileColor,
    required this.getTileTextColor,
  });

  @override
  State<_MergeTilesPage> createState() => _MergeTilesPageState();
}

class _MergeTilesPageState extends State<_MergeTilesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _step = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _startLoop();
  }

  Future<void> _startLoop() async {
    while (mounted) {
      setState(() => _step = 0); // 2, 2
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;

      setState(() => _step = 1); // merge → 4
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;

      setState(() => _step = 2); // 8, 8
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;

      setState(() => _step = 3); // merge → 16
      await Future.delayed(const Duration(milliseconds: 1200));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mergePairs = [
      [2, 2, 2, 2],
      [4, 0, 4, 0],
      [8, 8, 8, 8],
      [16, 0, 16, 0],
    ];

    final displayValues = mergePairs[_step];
    final isMerged = _step == 1 || _step == 3;

    // Use MediaQuery — always has real bounded width inside a PageView
    return LayoutBuilder(builder: (context, outer) {
      final w = outer.maxWidth.isFinite
          ? outer.maxWidth
          : MediaQuery.of(context).size.width;
      final ts = ((w - 64 - 80) / 2).clamp(40.0, 68.0);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _mergeRow(context, displayValues[0], displayValues[1], ts, 0, 1,
                isMerged ? Icons.add_rounded : Icons.arrow_forward_rounded,
                isMerged ? '= ${displayValues[0]}' : '+'),
            const SizedBox(height: 20),
            _mergeRow(
                context,
                displayValues[2],
                displayValues[3],
                ts,
                2,
                3,
                _step >= 2
                    ? (_step >= 3
                        ? Icons.add_rounded
                        : Icons.arrow_forward_rounded)
                    : Icons.add_rounded,
                _step >= 3
                    ? '= ${displayValues[2]}'
                    : _step >= 2
                        ? '+'
                        : ''),
            const SizedBox(height: 40),
            Text(
              'Tiles with the same number\nmerge into a larger tile.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              '2 + 2 = 4, 4 + 4 = 8, and so on...',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 15,
                  ),
            ),
          ],
        ),
      );
    });
  }

  Widget _mergeRow(BuildContext context, int v1, int v2, double ts, int i1,
      int i2, IconData icon, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMergeTile(v1, ts, i1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(icon,
              color: Theme.of(context).primaryColor.withOpacity(0.6), size: 20),
        ),
        _buildMergeTile(v2, ts, i2),
        const SizedBox(width: 10),
        SizedBox(
          width: 52,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              label,
              key: ValueKey(label),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 17,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMergeTile(int value, double size, int index) {
    final isMergedNow = (_step == 1 && (index == 0 || index == 1)) ||
        (_step == 3 && (index == 2 || index == 3));

    return AnimatedScale(
      scale: isMergedNow ? 1.15 : 1.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: size,
        height: size,
        child: _DemoTile(
          value: value,
          tileColor: widget.getTileColor(value),
          textColor: widget.getTileTextColor(value),
        ),
      ),
    );
  }
}

// ─── Page 3: New Tile Appears ───────────────────────────────────────────────

class _NewTilePage extends StatefulWidget {
  final Color Function(int) getTileColor;
  final Color Function(int) getTileTextColor;

  const _NewTilePage({
    required this.getTileColor,
    required this.getTileTextColor,
  });

  @override
  State<_NewTilePage> createState() => _NewTilePageState();
}

class _NewTilePageState extends State<_NewTilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeScale;
  bool _showNewTile = false;

  final List<List<int>> _grid = [
    [0, 0, 0, 0],
    [0, 2, 4, 0],
    [0, 0, 0, 0],
    [0, 0, 2, 0],
  ];

  final Point<int> _newTilePos = Point(0, 2);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeScale = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutBack,
    );
    _startLoop();
  }

  Future<void> _startLoop() async {
    while (mounted) {
      setState(() => _showNewTile = false);
      _fadeController.reset();
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;

      setState(() => _showNewTile = true);
      _fadeController.forward();
      await Future.delayed(const Duration(milliseconds: 2000));
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : MediaQuery.of(context).size.width;

      const double gap = 6.0;
      const double boardPadding = 8.0;
      final boardSize = (availableWidth - 64).clamp(120.0, 280.0);
      final innerSize = boardSize - boardPadding * 2;
      final tileSize = (innerSize - gap * 5) / 4;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: boardSize,
              height: boardSize,
              padding: const EdgeInsets.all(boardPadding),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .extension<GameThemeExtension>()
                    ?.tileColors[0]
                    ?.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(4, (row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: gap),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(4, (col) {
                        final value = _grid[row][col];
                        final isNewTile =
                            row == _newTilePos.x && col == _newTilePos.y;
                        return Padding(
                          padding: const EdgeInsets.only(left: gap),
                          child: SizedBox(
                            width: tileSize,
                            height: tileSize,
                            child: isNewTile && _showNewTile
                                ? FadeTransition(
                                    opacity: _fadeScale,
                                    child: ScaleTransition(
                                      scale: _fadeScale,
                                      child: _DemoTile(
                                        value: value,
                                        tileColor: widget.getTileColor(value),
                                        textColor:
                                            widget.getTileTextColor(value),
                                      ),
                                    ),
                                  )
                                : _DemoTile(
                                    value: isNewTile ? 0 : value,
                                    tileColor: widget
                                        .getTileColor(isNewTile ? 0 : value),
                                    textColor: widget.getTileTextColor(
                                        isNewTile ? 0 : value),
                                  ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          const SizedBox(height: 40),
          Text(
            'Every move creates a new tile.\nPlan ahead.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'A new 2 or 4 tile appears after each swipe.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 15,
                ),
          ),
        ],
      ),
    );
    });
  }
}

// ─── Page 4: Win & Tips ────────────────────────────────────────────────────

class _WinTipsPage extends StatefulWidget {
  final Color Function(int) getTileColor;
  final Color Function(int) getTileTextColor;
  final VoidCallback onPlay;

  const _WinTipsPage({
    required this.getTileColor,
    required this.getTileTextColor,
    required this.onPlay,
  });

  @override
  State<_WinTipsPage> createState() => _WinTipsPageState();
}

class _WinTipsPageState extends State<_WinTipsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _show2048 = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _startMerge();
  }

  Future<void> _startMerge() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _show2048 = true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Keep your biggest tile in one corner.',
      'Don\'t fill the board.',
      'Think a few moves ahead.',
    ];

    return LayoutBuilder(builder: (context, outer) {
      final w = outer.maxWidth.isFinite
          ? outer.maxWidth
          : MediaQuery.of(context).size.width;
      final ts = ((w - 64 - 68) / 3).clamp(44.0, 72.0);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Win animation: 1024 + 1024 → 2048
            AnimatedScale(
              scale: _show2048 ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: ts,
                    height: ts,
                    child: _DemoTile(
                      value: 1024,
                      tileColor: widget.getTileColor(1024),
                      textColor: widget.getTileTextColor(1024),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.add_rounded,
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.6),
                        size: 20),
                  ),
                  SizedBox(
                    width: ts,
                    height: ts,
                    child: _DemoTile(
                      value: 1024,
                      tileColor: widget.getTileColor(1024),
                      textColor: widget.getTileTextColor(1024),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.arrow_forward_rounded,
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.6),
                        size: 20),
                  ),
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        width: ts,
                        height: ts,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: widget
                                  .getTileColor(2048)
                                  .withOpacity(_glowAnimation.value * 0.6),
                              blurRadius: 24 * _glowAnimation.value,
                              spreadRadius: 2 * _glowAnimation.value,
                            ),
                          ],
                        ),
                        child: _DemoTile(
                          value: 2048,
                          tileColor: widget.getTileColor(2048),
                          textColor: widget.getTileTextColor(2048),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Celebration confetti dots
            AnimatedOpacity(
              opacity: _show2048 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (i) {
                  final colors = [
                    widget.getTileColor(2),
                    widget.getTileColor(4),
                    widget.getTileColor(8),
                    widget.getTileColor(16),
                    widget.getTileColor(64),
                    widget.getTileColor(128),
                    widget.getTileColor(2048),
                  ];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: AnimatedScale(
                      scale: _show2048 ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 400 + i * 100),
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colors[i],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Reach 2048 to win!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
            ),
            const SizedBox(height: 24),
            // Tips
            ...tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_rounded,
                          color: widget.getTileColor(8), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          tip,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 15,
                                  ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );
    });
  }
}
