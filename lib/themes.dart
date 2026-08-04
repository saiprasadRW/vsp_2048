import 'package:flutter/material.dart';
import 'package:flutter_2048/game_theme_extension.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeMode {
  light,
  dark,
  gothicWhite,
  gothicDark,
  blush,
  redDragon,
  starlight,
  devMode
}

class AppThemes {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,

    //Primary textColor
    primaryColor: Colors.black,

    //Secondary textColor
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.black,

    //Radio button theme
    radioTheme: const RadioThemeData(
      mouseCursor: WidgetStatePropertyAll(MouseCursor.uncontrolled),
      fillColor: WidgetStatePropertyAll(Colors.deepOrange),
    ),

    //AppBar theme
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        ),
        toolbarHeight: 120,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        )),

    //Background color of app
    scaffoldBackgroundColor: Colors.white,

    //Score Card Color
    cardColor: const Color(0xFF808080),

    //Text Styles
    textTheme: const TextTheme(

        //TextStyle for theme list
        displaySmall: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),

        //Score Card title TextStyle
        headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),

        //Restart game text, Score value TextStyle
        bodySmall: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600),

        //Tile TextStyle
        bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600),

        //Game Over/Won TextStyle
        headlineLarge: TextStyle(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        )),

    extensions: [
      GameThemeExtension(
        //Tile colors for different values
        tileColors: const {
          0: Color(0xFF2B2B2B),
          2: Color(0xFFFF6B6B),
          4: Color(0xFFFFA94D),
          8: Color(0xFFFFD43B),
          16: Color(0xFF51CF66),
          32: Color(0xFF38D9A9),
          64: Color(0xFF4DABF7),
          128: Color(0xFF5C7CFA),
          256: Color(0xFF845EF7),
          512: Color(0xFFDA77F2),
          1024: Color(0xFFFF66CC),
          2048: Color(0xFFFFC107),
        },
        defaultTileColor: const Color(0xFF808080),

        //Game Over background color
        gameOverBackgroundColor: Colors.black.withOpacity(0.8),
      )
    ],
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,

    //Primary textColor
    primaryColor: Colors.white,

    //Secondary textColor
    primaryColorDark: Colors.black,
    primaryColorLight: Colors.white,

    //Radio button theme
    radioTheme: const RadioThemeData(
      mouseCursor: WidgetStatePropertyAll(MouseCursor.uncontrolled),
      fillColor: WidgetStatePropertyAll(Colors.deepPurple),
    ),

    //AppBar theme
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
        toolbarHeight: 120,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        )),

    //Background color of app
    scaffoldBackgroundColor: Colors.black,

    //Score Card Color
    cardColor: const Color(0xFF808080),

    //Text Styles
    textTheme: const TextTheme(

        //TextStyle for theme list
        displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),

        //Score Card title TextStyle
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),

        //Restart game text, Score value TextStyle
        bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600),

        //Tile TextStyle
        bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600),

        //Game Over/Won TextStyle
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        )),

    extensions: [
      GameThemeExtension(
        //Tile colors for different values
        tileColors: const {
          0: Color(0xFF2B2B2B),
          2: Color(0xFFFF6B6B),
          4: Color(0xFFFFA94D),
          8: Color(0xFFFFD43B),
          16: Color(0xFF51CF66),
          32: Color(0xFF38D9A9),
          64: Color(0xFF4DABF7),
          128: Color(0xFF5C7CFA),
          256: Color(0xFF845EF7),
          512: Color(0xFFDA77F2),
          1024: Color(0xFFFF66CC),
          2048: Color(0xFFFFC107),
        },
        defaultTileColor: const Color(0xFF808080),

        //Game Over background color
        gameOverBackgroundColor: Colors.black.withOpacity(0.8),
      )
    ],
  );

  static final ThemeData gothicWhite = ThemeData(
    brightness: Brightness.light,

    //Primary textColor
    primaryColor: Colors.black,

    //Secondary textColor
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.black,

    //Radio button theme
    radioTheme: const RadioThemeData(
      mouseCursor: WidgetStatePropertyAll(MouseCursor.uncontrolled),
      fillColor: WidgetStatePropertyAll(Colors.black),
    ),

    //AppBar theme
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        ),
        toolbarHeight: 120,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          // fontWeight: FontWeight.bold,
          fontFamily: 'Special Gothic Expanded One',
        )),

    //Background color of app
    scaffoldBackgroundColor: Colors.white,

    //Score Card Color
    cardColor: const Color.fromARGB(255, 66, 36, 173),

    //Text Styles
    textTheme: const TextTheme(

        //TextStyle for theme list
        displaySmall: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Special Gothic Expanded One',
        ),

        //Score Card title TextStyle
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Special Gothic Expanded One',
        ),

        //Restart game text, Score value TextStyle
        bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Special Gothic Expanded One',
            fontWeight: FontWeight.w600),

        //Tile TextStyle
        bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Special Gothic Expanded One',
            fontWeight: FontWeight.w600),

        //Game Over/Won TextStyle
        headlineLarge: TextStyle(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Special Gothic Expanded One',
        )),

    extensions: [
      GameThemeExtension(
        //Tile colors for different values
        tileColors: const {
          0: Color(0xFF2B2B2B), // Common tile (dark neutral gray)
          2: Color(0xFFFF6B6B), // Vibrant Red
          4: Color(0xFFFFA94D), // Bright Orange
          8: Color(0xFFFFD43B), // Golden Yellow
          16: Color(0xFF51CF66), // Lush Green
          32: Color(0xFF38D9A9), // Aqua Green
          64: Color(0xFF4DABF7), // Sky Blue
          128: Color(0xFF5C7CFA), // Indigo Blue
          256: Color(0xFF845EF7), // Vivid Purple
          512: Color(0xFFDA77F2), // Orchid Pink
          1024: Color(0xFFFF66CC), // Neon Pink
          2048: Color(0xFFFFC107), // Bright Amber Gold (Victory Tile!)
        },
        defaultTileColor: const Color(0xFF808080),

        //Game Over background color
        gameOverBackgroundColor: Colors.black.withOpacity(0.8),
      )
    ],
  );

  static final ThemeData gothicDark = ThemeData(
    brightness: Brightness.dark,

    //Primary textColor
    primaryColor: Colors.white,

    //Secondary textColor
    primaryColorDark: Colors.black,
    primaryColorLight: Colors.white,

    //Radio button theme
    radioTheme: const RadioThemeData(
      mouseCursor: WidgetStatePropertyAll(MouseCursor.uncontrolled),
      fillColor: WidgetStatePropertyAll(Colors.white),
    ),

    //AppBar theme
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
        toolbarHeight: 120,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          // fontWeight: FontWeight.bold,
          fontFamily: 'Special Gothic Expanded One',
        )),

    //Background color of app
    scaffoldBackgroundColor: Colors.black,

    //Score Card Color
    cardColor: const Color.fromARGB(255, 66, 36, 173),

    //Text Styles
    textTheme: const TextTheme(

        //TextStyle for theme list
        displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Special Gothic Expanded One',
        ),

        //Score Card title TextStyle
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Special Gothic Expanded One',
        ),

        //Restart game text, Score value TextStyle
        bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Special Gothic Expanded One',
            fontWeight: FontWeight.w600),

        //Tile TextStyle
        bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Special Gothic Expanded One',
            fontWeight: FontWeight.w600),

        //Game Over/Won TextStyle
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Special Gothic Expanded One',
        )),

    extensions: [
      GameThemeExtension(
        //Tile colors for different values
        tileColors: const {
          0: Color(0xFF2B2B2B), // Common tile (dark neutral gray)
          2: Color(0xFFFF6B6B), // Vibrant Red
          4: Color(0xFFFFA94D), // Bright Orange
          8: Color(0xFFFFD43B), // Golden Yellow
          16: Color(0xFF51CF66), // Lush Green
          32: Color(0xFF38D9A9), // Aqua Green
          64: Color(0xFF4DABF7), // Sky Blue
          128: Color(0xFF5C7CFA), // Indigo Blue
          256: Color(0xFF845EF7), // Vivid Purple
          512: Color(0xFFDA77F2), // Orchid Pink
          1024: Color(0xFFFF66CC), // Neon Pink
          2048: Color(0xFFFFC107), // Bright Amber Gold (Victory Tile!)
        },
        defaultTileColor: const Color(0xFF808080),

        //Game Over background color
        gameOverBackgroundColor: Colors.black.withOpacity(0.8),
      )
    ],
  );

  static final ThemeData blush = ThemeData(
    brightness: Brightness.light,

    //Primary textColor
    primaryColor: const Color(0xFFFDECEF),

    //Secondary textColor
    primaryColorLight: const Color(0xFFFFC8D4),
    primaryColorDark: const Color(0xFFB23A48),

    //Radio button theme
    radioTheme: const RadioThemeData(
      mouseCursor: WidgetStatePropertyAll(MouseCursor.uncontrolled),
      fillColor: WidgetStatePropertyAll(Color(0xFFFFAEC0)),
    ),

    //AppBar theme
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFB23A48),
        actionsIconTheme: IconThemeData(
          color: Color(0xFFFFE6E8),
        ),
        toolbarHeight: 120,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        titleTextStyle: TextStyle(
          color: Color(0xFFFFEEF2),
          fontSize: 24,
          // fontWeight: FontWeight.bold,
          fontFamily: 'DM Serif Display',
        )),

    //Background color of app
    scaffoldBackgroundColor: const Color(0xFFFFE6E8),

    //Score Card Color
    cardColor: const Color(0xFFF8C8DC),

    //Text Styles
    textTheme: const TextTheme(

        //TextStyle for theme list
        displaySmall: TextStyle(
          color: Color(0xFF6B0F1A),
          fontSize: 16,
          fontFamily: 'DM Serif Display',
        ),

        //Score Card title TextStyle
        headlineSmall: TextStyle(
          color: Color(0xFF6B0F1A),
          fontSize: 20,
          fontFamily: 'DM Serif Display',
        ),

        //Restart game text, Score value TextStyle
        bodySmall: TextStyle(
            color: Color(0xFFB23A48),
            fontSize: 16,
            fontFamily: 'DM Serif Display',
            fontWeight: FontWeight.w600),

        //Tile TextStyle
        bodyLarge: TextStyle(
            color: Color(0xFFFDECEF),
            fontSize: 24,
            fontFamily: 'DM Serif Display',
            fontWeight: FontWeight.w600),

        //Game Over/Won TextStyle
        headlineLarge: TextStyle(
          color: Color(0xFFFDECEF),
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'DM Serif Display',
        )),

    extensions: [
      GameThemeExtension(
        //Tile colors for different values
        tileColors: const {
          0: Color(0xFFFFE6E8), // same as background
          2: Color(0xFFFFC1CC), // light pink
          4: Color(0xFFFFA3B5), // bubblegum pink
          8: Color(0xFFFF7F9C), // rose
          16: Color(0xFFFF5D89), // flamingo pink
          32: Color(0xFFFF3B6F), // hot pink
          64: Color(0xFFD61C4E), // romantic red
          128: Color(0xFFB23A48), // deep rose
          256: Color(0xFF781C2D), // dark wine
          512: Color(0xFF5E1426), // deep burgundy
          1024: Color(0xFF3E0E1B), // almost black cherry
          2048: Color(0xFF24000F), // deep love tone
        },
        defaultTileColor: const Color(0xFF808080),

        //Game Over background color
        gameOverBackgroundColor: Colors.black.withOpacity(0.8),
      )
    ],
  );

  static final ThemeData redDragon = ThemeData(
    brightness: Brightness.dark,

    //Primary textColor
    primaryColor: const Color(0xFFD4AF37),

    //Secondary textColor
    primaryColorDark: const Color(0xFFB60000),
    primaryColorLight: const Color(0xFFF6E27F),
    //Radio button theme
    radioTheme: RadioThemeData(
      mouseCursor: const WidgetStatePropertyAll(MouseCursor.uncontrolled),
      fillColor: WidgetStatePropertyAll(Colors.yellow[200]!),
    ),

    //AppBar theme
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFB60000),
        actionsIconTheme: IconThemeData(
          color: Color(0xFFF6E27F),
        ),
        toolbarHeight: 120,
        titleTextStyle: TextStyle(
          color: Color(0xFFD4AF37),
          fontSize: 24,
          // fontWeight: FontWeight.bold,
          fontFamily: 'Wonton',
        )),

    //Background color of app
    scaffoldBackgroundColor: Colors.transparent,

    //Score Card Color
    cardColor: const Color(0xff2B2B2B),

    //Text Styles
    textTheme: const TextTheme(

        //TextStyle for theme list
        displaySmall: TextStyle(
          color: Color(0xFFF6E27F),
          fontSize: 16,
          fontFamily: 'Wonton',
        ),

        //Score Card title TextStyle
        headlineSmall: TextStyle(
          color: Color(0xFFF6E27F),
          fontSize: 20,
          fontFamily: 'Wonton',
        ),

        //Restart game text, Score value TextStyle
        bodySmall: TextStyle(
            color: Color(0xFFF6E27F),
            fontSize: 16,
            fontFamily: 'Wonton',
            fontWeight: FontWeight.w600),

        //Tile TextStyle
        bodyLarge: TextStyle(
            color: Color(0xFFF6E27F),
            fontSize: 24,
            fontFamily: 'Wonton',
            fontWeight: FontWeight.w600),

        //Game Over/Won TextStyle
        headlineLarge: TextStyle(
          color: Color(0xFFF6E27F),
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Wonton',
        )),

    extensions: [
      GameThemeExtension(
        //Tile colors for different values
        tileColors: const {
          0: Color(0xFF6A0000), // Muted dark crimson (neutral tile)

          2: Color(0xFF8B1A1A), // Blood red (low value, blends but visible)
          4: Color(0xFFA83232), // Rose crimson
          8: Color(0xFFCC5C2C), // Rustic copper

          16: Color(0xFFE68A00), // Golden amber
          32: Color(0xFFF6C340), // Buttery gold
          64: Color(0xFFF6E27F), // Champagne gold (matches text color)

          128: Color(0xFFD4AF37), // Metallic gold
          256: Color(0xFFB08D57), // Antique bronze
          512: Color(0xFF9E7B4F), // Deep rose gold

          1024: Color(0xFFDAA520), // Goldenrod
          2048: Color(0xFFFFC107), // Bright victory gold
        },

        defaultTileColor: const Color(0xFF6A0000), // Neutral dark tile

        //Game Over background color
        gameOverBackgroundColor: Colors.black.withOpacity(0.8),

        isImage: true,
        imagePath: 'assets/red_dragon.jpeg',
      )
    ],
  );

  static final ThemeData starlight = ThemeData(
    brightness: Brightness.dark,

    //Primary textColor
    primaryColor: const Color(0xFFFFD700),

    //Secondary textColor
    primaryColorDark: const Color(0xFFFF1744),
    primaryColorLight: const Color(0xFF2979FF),

    //Radio button theme
    radioTheme: const RadioThemeData(
      mouseCursor: WidgetStatePropertyAll(MouseCursor.uncontrolled),
      fillColor: WidgetStatePropertyAll(Color(0xFFFFD700)),
    ),

    //AppBar theme
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        actionsIconTheme: const IconThemeData(
          color: Color(0xFFFFD700),
        ),
        toolbarHeight: 120,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        titleTextStyle: GoogleFonts.michroma(
          color: const Color(0xFFFFD700),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        )),

    //Background color of app
    scaffoldBackgroundColor: const Color(0xFF0D1B2A),

    //Score Card Color
    cardColor: const Color(0xFF1B2838),

    //Text Styles
    textTheme: TextTheme(

        //TextStyle for theme list
        displaySmall: GoogleFonts.michroma(
          color: const Color(0xFFFFD700),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        //Score Card title TextStyle
        headlineSmall: GoogleFonts.michroma(
          color: const Color(0xFFFFD700),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),

        //Restart game text, Score value TextStyle
        bodySmall: GoogleFonts.michroma(
            color: const Color(0xFFFF1744),
            fontSize: 16,
            fontWeight: FontWeight.w600),

        //Tile TextStyle
        bodyLarge: GoogleFonts.michroma(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),

        //Game Over/Won TextStyle
        headlineLarge: GoogleFonts.michroma(
          color: const Color(0xFFFFD700),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        )),

    extensions: [
      GameThemeExtension(
        //Tile colors for different values
        tileColors: const {
          0: Color(0xFF08121F), // Background - Deep Navy
          2: Color(0xFF2D8CFF), // Electric Blue
          4: Color(0xFFE53935), // Superstar Red
          8: Color(0xFFFFD54F), // Warm Gold
          16: Color(0xFFFFB300), // Golden Amber
          32: Color(0xFF1565C0), // Royal Blue
          64: Color(0xFFC62828), // Deep Red
          128: Color(0xFFFFC107), // Rich Gold
          256: Color(0xFFD32F2F), // Crimson Red
          512: Color(0xFF42A5F5), // Sky Blue
          1024: Color(0xFFFF8F00), // Orange Gold
          2048: Color(0xFFFFE082), // Superstar Gold
        },
        //Text color overrides for blue and red tiles
        tileTextColor: const {
          0: Color(0xFFFFFFFF),
          2: Colors.white,
          4: Colors.white,
          8: Color(0xFF1A1A1A),
          16: Color(0xFF1A1A1A),
          32: Colors.white,
          64: Colors.white,
          128: Color(0xFF1A1A1A),
          256: Colors.white,
          512: Color(0xFF0D1B2A),
          1024: Color(0xFF1A1A1A),
          2048: Color(0xFF0D1B2A),
        },
        defaultTileColor: const Color(0xFF1B2838),

        //Game Over background color
        gameOverBackgroundColor: Colors.black.withOpacity(0.8),

        // DotField background
        hasDotField: true,
        dotFieldGradientFrom: const Color.fromRGBO(30, 100, 220, 0.35),
        dotFieldGradientTo: const Color.fromRGBO(100, 160, 230, 0.25),
      )
    ],
  );

  static final ThemeData devMode = ThemeData(
    brightness: Brightness.dark,

    // Primary text color
    primaryColor: const Color(0xFF58A6FF), // VS Code Blue

    // Secondary text colors
    primaryColorDark: const Color(0xFF39D353), // Success Green
    primaryColorLight: const Color(0xFF7EE787), // Light Green

    // Radio Button Theme
    radioTheme: const RadioThemeData(
      mouseCursor: WidgetStatePropertyAll(MouseCursor.uncontrolled),
      fillColor: WidgetStatePropertyAll(Color(0xFF39D353)),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      toolbarHeight: 120,
      actionsIconTheme: const IconThemeData(
        color: Color(0xFF58A6FF),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      titleTextStyle: GoogleFonts.jetBrainsMono(
        color: const Color(0xFF58A6FF),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Background
    scaffoldBackgroundColor: const Color(0xFF0D1117),

    // Score Card
    cardColor: const Color(0xFF161B22),

    // Text Styles
    textTheme: TextTheme(
      // Theme List
      displaySmall: GoogleFonts.jetBrainsMono(
        color: const Color(0xFF58A6FF),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      // Score Title
      headlineSmall: GoogleFonts.jetBrainsMono(
        color: const Color(0xFF58A6FF),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),

      // Score Value / Restart
      bodySmall: GoogleFonts.jetBrainsMono(
        color: const Color(0xFF39D353),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      // Tile Value
      bodyLarge: GoogleFonts.jetBrainsMono(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),

      // Win / Game Over
      headlineLarge: GoogleFonts.jetBrainsMono(
        color: const Color(0xFF39D353),
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ),

    extensions: [
      GameThemeExtension(
        // Tile Colors
        tileColors: const {
          0: Color(0xFF132749),
          2: Color(0xFF9CDCFE),
          4: Color(0xFF9DD4CF),
          8: Color(0xFFA4D4A3),
          16: Color(0xFF77CACB),
          32: Color(0xFFDA70D6),
          64: Color(0xFF179FF1),
          128: Color(0xFFffc914),
          256: Color(0xFFFFBC00),
          512: Color(0xFFFFB256),
          1024: Color(0xFFFEA984),
          2048: Color(0xFFFF7858),
        },

        // Tile Text Colors
        tileTextColor: const {
          0: Colors.white,
          2: Color(0xFF132749),
          4: Color(0xFF132749),
          8: Color(0xFF132749),
          16: Color(0xFF132749),
          32: Colors.white,
          64: Colors.white,
          128: Color(0xFF132749),
          256: Color(0xFF132749),
          512: Color(0xFF132749),
          1024: Color(0xFF132749),
          2048: Colors.white,
        },

        defaultTileColor: const Color(0xFF132749),

        // Overlay
        gameOverBackgroundColor: Colors.black.withOpacity(0.85),

        // Matrix Background
        hasMatrixBg: true,
      ),
    ],
  );
}
