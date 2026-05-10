import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dummypage extends StatefulWidget {
  const Dummypage({super.key});

  @override
  State<Dummypage> createState() => _DummypageState();
}

class _DummypageState extends State<Dummypage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Home Screen")),
    );
  }
}
