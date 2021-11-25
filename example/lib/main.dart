import 'package:atoms/atoms.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: Atoms(
          backgroundColor: Color(0xff00001a),
          minVelocity: 0.2,
          maxVelocity: 1,
          nAtoms: 100,
          atomParameters: Atom(
            atomsColor: Colors.white,
            webColor:  Colors.white,
            atomsDiameter: 2,
            maxDistance: 140,
          ),
        ),
      ),
    );
  }
}
