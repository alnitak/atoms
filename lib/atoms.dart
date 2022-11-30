library atoms;

import 'dart:math';

import 'package:flutter/material.dart';

/// class to store atom parameters
class Atom {
  /// atoms diameter
  final double atomsDiameter;

  /// atoms color
  final Color atomsColor;

  /// web color
  final Color webColor;

  /// max distance to draw the web
  final double maxDistance;

  const Atom({
    this.atomsDiameter = 3,
    this.atomsColor = Colors.white,
    this.webColor = Colors.white,
    this.maxDistance = 100,
  });
}

/// class to store position
class _AtomPhysics {
  Point pos;
  Point offsetPerTick;

  _AtomPhysics(this.pos, this.offsetPerTick);
}


class Atoms extends StatefulWidget {
  /// the number of atoms
  final int nAtoms;

  /// background color
  final Color backgroundColor;

  /// atom parameters
  final Atom atomParameters;

  /// minimum offset for each tick
  final double minVelocity;

  /// maximum offset for each tick
  final double maxVelocity;

  const Atoms({
    Key? key,
    this.nAtoms = 100,
    this.backgroundColor = Colors.black,
    this.atomParameters = const Atom(),
    this.minVelocity = 2.0,
    this.maxVelocity = 3.0,
  }) : super(key: key);

  @override
  _AtomsState createState() => _AtomsState();
}


class _AtomsState extends State<Atoms>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController? controller;

  late List<_AtomPhysics> atoms;
  late double _width;
  late double _height;

  @override
  void initState() {
    super.initState();

    atoms = [];
    _width = 0;
    _height = 0;

    WidgetsBinding.instance.addObserver(this);

    /// at the first frame get the widget size
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final RenderObject? object = context.findRenderObject();
      final Size size = object?.semanticBounds.size ?? Size.zero;
      _width = size.width;
      _height = size.height;

      /// initialize atoms
      if (atoms.isEmpty) {
        _generateAtoms();
        setState(() {});
      }
    });
  }

  /// generate the atoms list with random position and velocity
  _generateAtoms() {
    if (_width == 0 || _height == 0) return;
    controller?.removeListener(calcAtoms);
    controller?.stop();
    controller?.dispose();
    atoms.clear();
    for (int i = 0; i < widget.nAtoms; i++) {
      atoms.add(_AtomPhysics(
        Point(
          Random().nextDouble() * _width,
          Random().nextDouble() * _height,
        ),
        Point(
          (Random().nextInt(2) * 2 - 1) * (widget.minVelocity +
              (Random().nextDouble() - 0.5) *
                  (widget.maxVelocity - widget.minVelocity)),
          (Random().nextInt(2) * 2 - 1) * (widget.minVelocity +
              (Random().nextDouble() - 0.5) *
                  (widget.maxVelocity - widget.minVelocity)),
        ),
      ));
    }

    controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1))
      ..addListener(() => calcAtoms());
    controller?.repeat();
  }

  calcAtoms() {
    if (atoms.isEmpty) return;
    for (int i=0; i<widget.nAtoms; i++) {
      atoms[i].pos += atoms[i].offsetPerTick;
      if (atoms[i].pos.x  < 0 || atoms[i].pos.x > _width ||
          atoms[i].pos.y  < 0 || atoms[i].pos.y > _height) {
        atoms[i].pos = Point(
          Random().nextDouble() * _width,
          Random().nextDouble() * _height,
        );
      }
    }
    setState(() {});
  }

  /// catch hot reload. Should be triggered 2 times!!! ( ctrl+/   or  ctrl+s )
  @override
  void reassemble() {
    _generateAtoms();
    super.reassemble();
  }


  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final RenderObject? object = context.findRenderObject();
      final Size size = object?.semanticBounds.size ?? Size.zero;
      _width = size.width;
      _height = size.height;

      /// initialize atoms
      if (atoms.isEmpty) {
        _generateAtoms();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (atoms.isEmpty) return Container();

    return ClipRRect(
      child: Container(
        color: widget.backgroundColor,
        child: CustomPaint(
          isComplex: true,
          painter: DrawAtoms(
              atoms: atoms,
              atomParameters: widget.atomParameters
          ),
        ),
      ),
    );
  }

}

/// Custom painter to draw atoms and web
class DrawAtoms extends CustomPainter {
  final Atom atomParameters;
  final List<_AtomPhysics> atoms;

  DrawAtoms({
    required this.atoms,
    required this.atomParameters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = atomParameters.atomsColor;

    for (int n=0; n<atoms.length; n++) {
      canvas.drawCircle(
        Offset(atoms.elementAt(n).pos.x.toDouble(), atoms.elementAt(n).pos.y.toDouble()),
        atomParameters.atomsDiameter,
        paint
      );
    }

    double distance;
    double opacity;
    for (int a=0; a<atoms.length; a++) {
      for (int b=0; b<atoms.length; b++) {
        distance = atoms[a].pos.distanceTo(atoms[b].pos);
        if (distance < atomParameters.maxDistance) {
          opacity = 1.0 - distance / atomParameters.maxDistance;
          paint.color = atomParameters.webColor.withOpacity(opacity);
          canvas.drawLine(
              Offset(atoms[a].pos.x.toDouble(), atoms[a].pos.y.toDouble()),
              Offset(atoms[b].pos.x.toDouble(), atoms[b].pos.y.toDouble()),
              paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}