import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 132, 24, 142),
              child: const Column(
                children: [],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  ref.watch(currentCenterPlanet)?.name ?? 'nada',
                  style: const TextStyle(color: Colors.white, fontSize: 32),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: pi / 12.0,
                        child: PlanetStack(animationValue: _controller.value),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      _controller.animateTo(_controller.value + 1 / 9,
                          curve: Curves.decelerate);
                    },
                    child: const Text('frent')),
                ElevatedButton(
                    onPressed: () {
                      _controller.animateTo(_controller.value - 1 / 9,
                          curve: Curves.decelerate);
                    },
                    child: const Text('tras'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlanetStack extends ConsumerStatefulWidget {
  final double animationValue;
  const PlanetStack({required this.animationValue, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlanetStackState();
}

class _PlanetStackState extends ConsumerState<PlanetStack> {
  List<Planet> planetsList = planetNames;

  static const double circunference = 2 * pi;

  double get animationValue => widget.animationValue;

  int get totalPlanets => planetsList.length;

  List<double> get zCoordinates {
    return List.generate(totalPlanets, (index) {
      double angle = index * circunference / totalPlanets +
          circunference * animationValue +
          pi / 2;

      return 20 * sin(angle);
    });
  }

  List<int> get sortedIndexesByDepth {
    final indexesList = List.generate(totalPlanets, (index) => index);

    indexesList.sort((a, b) => zCoordinates[a].compareTo(zCoordinates[b]));

    return indexesList;
  }

  double get screenWidth {
    return MediaQuery.of(context).size.width - 300;
  }

  double get screenHeight {
    return MediaQuery.of(context).size.height;
  }

  List<Widget> get planetsWidgetList {
    final planetsWidgets = List.generate(totalPlanets, (index) {
      final planetIndex = sortedIndexesByDepth[index];

      double angle = planetIndex * circunference / totalPlanets +
          circunference * animationValue +
          pi / 2;

      final x = screenWidth / 3 * cos(angle);
      final y = 20 * sin(angle);

      const depth = 12.0;
      const perspective = 0.022;

      final scale = depth / (depth - y * perspective);

      return Positioned(
        left: x + screenWidth / 2 - planetsList[planetIndex].radius / 2,
        top: y + screenHeight / 2 - planetsList[planetIndex].radius / 2,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(1, 2, perspective)
            ..scale(scale, scale),
          child: PlanetWidget(planet: planetsList[planetIndex]),
        ),
      );
    });

    double sunSize = 150;

    Future(
      () => ref.read(currentCenterPlanet.notifier).state =
          planetsList[sortedIndexesByDepth.last],
    );

    planetsWidgets.insert(
      4,
      Positioned(
        left: screenWidth / 2 - sunSize / 2,
        top: screenHeight / 2 - sunSize / 2,
        child: PlanetWidget(
          planet: Planet(
            asset: 'assets/sol.png',
            name: 'Sun',
            radius: sunSize,
          ),
        ),
      ),
    );

    return planetsWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: planetsWidgetList,
    );
  }
}

class PlanetWidget extends StatefulWidget {
  final Planet planet;

  const PlanetWidget({super.key, required this.planet});

  @override
  State<PlanetWidget> createState() => _PlanetWidgetState();
}

class _PlanetWidgetState extends State<PlanetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 10.0,
      duration: const Duration(seconds: 50),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.planet.radius,
          height: widget.planet.radius,
          child: ClipOval(
            child: Stack(
              children: [
                Positioned(
                  left: _controller.value * -10,
                  top: -widget.planet.radius / 2,
                  child: Image.asset(
                    widget.planet.asset,
                    width: widget.planet.radius * 4.5,
                    height: widget.planet.radius * 2.5,
                  ),
                ),
                Positioned(
                  child: Container(
                    width: widget.planet.radius,
                    height: widget.planet.radius,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

const double baseRadius = 50.0;

List<Planet> planetNames = [
  Planet(asset: 'assets/terra.png', name: 'Fubá', radius: baseRadius + 5),
  Planet(
    asset: 'assets/mercurio.png',
    name: 'Mercúrio',
    radius: baseRadius - 20,
  ),
  Planet(asset: 'assets/venus.png', name: 'Vênus', radius: baseRadius + 10),
  Planet(asset: 'assets/terra.png', name: 'Terra', radius: baseRadius + 0),
  Planet(asset: 'assets/marte.png', name: 'Marte', radius: baseRadius + 10),
  Planet(asset: 'assets/jupiter.png', name: 'Júpiter', radius: baseRadius + 5),
  Planet(
    asset: 'assets/saturno.png',
    name: 'Saturno',
    radius: baseRadius + 155,
  ),
  Planet(asset: 'assets/uranus.png', name: 'Urano', radius: baseRadius + 15),
  Planet(asset: 'assets/netuno.png', name: 'Netuno', radius: baseRadius + 5),
];

final currentCenterPlanet = StateProvider<Planet?>((ref) {
  return;
});

class Planet {
  final String asset;
  final String name;
  final double radius;

  Planet({
    required this.asset,
    required this.name,
    required this.radius,
  });
}
