// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planets_app/app/core/constants.dart';

class PlanetWidget extends ConsumerWidget {
  final String name;
  final AnimationController controller;
  final int index;
  const PlanetWidget({
    required this.index,
    required this.controller,
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double initialTheta = (2 * pi / Planets.totalSize) * index;
    planetListColors.shuffle();
    return AnimatedBuilder(
      animation: controller,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: planetListColors.first),
        child: Text(name),
      ),
      builder: (context, child) {
        double theta = initialTheta +
            (2 * pi / Planets.totalSize) * (controller.value / 2) * 2;
        print('theta $name = $initialTheta');
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Adiciona perspectiva
            ..rotateX(pi / 6) // Inclinação
            ..translate((100 * 1.25) * sin(theta), 100 * sin(theta)),
          child: child,
        );
      },
    );
  }
}
//     return Transform(
//             transform: Matrix4.identity()
//               ..setEntry(3, 2, 0.001) // Adiciona perspectiva
//               ..rotateX(pi / 4) // Inclinação
//               ..translate((100 * 1.25) * sin(theta), 100 * sin(theta)),






