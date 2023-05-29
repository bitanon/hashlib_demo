import 'package:flutter/material.dart';
import 'package:hashlib_demo/src/pages/about.dart';
import 'package:hashlib_demo/src/pages/auth.dart';
import 'package:hashlib_demo/src/pages/benchmark.dart';
import 'package:hashlib_demo/src/pages/demo.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hashlib Demo',
      home: const HomePage(),
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        primaryColor: Colors.amber,
        appBarTheme: const AppBarTheme(
          elevation: 10,
        ),
        searchBarTheme: const SearchBarThemeData(
          elevation: MaterialStatePropertyAll(2),
          textStyle: MaterialStatePropertyAll(
            TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.white60,
        ),
        snackBarTheme: const SnackBarThemeData(
          showCloseIcon: true,
          closeIconColor: Colors.white,
          backgroundColor: Colors.black,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        cardTheme: const CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.amberAccent,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 0;
  bool reversed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        onTap: (index) {
          reversed = page > index;
          page = index;
          setState(() => {});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Demo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            activeIcon: Icon(Icons.timer),
            label: 'Benchmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_key_outlined),
            activeIcon: Icon(Icons.vpn_key_sharp),
            label: 'OTP Auth',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            activeIcon: Icon(Icons.help),
            label: 'About',
          ),
        ],
      ),
      appBar: AppBar(
        title: <Widget>[
          const Text('Hashlib Demo'),
          const Text('Hashlib Benchmark'),
          const Text('Hashlib Authenticator'),
          const Text('About'),
        ][page],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        reverseDuration: Duration.zero,
        switchInCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(reversed ? -1 : 1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: <Widget>[
          const DemoPage(),
          const BenchmarkPage(),
          const AuthPage(),
          const AboutPage(),
        ][page],
      ),
    );
  }
}
