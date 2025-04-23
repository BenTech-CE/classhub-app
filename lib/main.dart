// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Classhub',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: Container(
//         color: Colors.white,
//         child: const Center(
//           child: Text(
//             'Hello World',
//             style: TextStyle(
//               fontSize: 24,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:classhub/views/auth/login/LoginView.dart';
import 'package:flutter/cupertino.dart';

/// Flutter code sample for [CupertinoTabBar].

void main() => runApp(const CupertinoTabBarApp());

class CupertinoTabBarApp extends StatelessWidget {
  const CupertinoTabBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: CupertinoTabBarExample(),
    );
  }
}

class CupertinoTabBarExample extends StatelessWidget {
  const CupertinoTabBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bookmark_solid), label: 'Mural'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.clock_solid), label: 'Recents'),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_alt_circle_fill),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.circle_grid_3x3_fill), label: 'Keypad'),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return Center(
                child: index == 0
                    ? const LoginView()
                    : Text('Content of tab $index'));
          },
        );
      },
    );
  }
}
