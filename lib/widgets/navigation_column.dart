import 'package:flutter/material.dart';

class NavigationColumn extends StatelessWidget {
  final List<String> screenTitles;
  final List<String> routeNames; // List to store route names

  const NavigationColumn(
      {super.key, required this.screenTitles, required this.routeNames});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        screenTitles.length,
        (index) => ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, routeNames[index]);
          },
          child: Text('Go to ${screenTitles[index]}'),
        ),
      ),
    );
  }
}
