import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planets_app/app/core/constants.dart';
import 'package:planets_app/app/pages/home/pods/home_pods.dart';

import 'components/planet_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _controller = AnimationController(
    lowerBound: 0.0,
    upperBound: Planets.totalSize.toDouble(),
    duration: const Duration(seconds: 10),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final planetsNotifier = ref.read(planetsProviderWidget.notifier);
      planetsNotifier.state = createOrderedPlanetWidgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          ElevatedButton(
              onPressed: () async {
                // Avançar
                _currentIndex = (_currentIndex + 1) % Planets.totalSize;
                // final lista = createOrderedPlanetWidgets;
                // ref.read(planetsProviderWidget.notifier).state = lista;

                await _controller.animateTo(_currentIndex.toDouble());
              },
              child: const Text('++')),
          ElevatedButton(
              onPressed: () async {
                // Retroceder
                if (_currentIndex == 0) {
                  _currentIndex = Planets.totalSize - 1;
                  _controller.value = Planets.totalSize
                      .toDouble(); // Ajustar o valor para um loop completo
                } else {
                  _currentIndex -= 1;
                }
                //reorderPlanets();
                await _controller.animateTo(_currentIndex.toDouble());
              },
              child: const Text('--'))
        ]),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: ref.watch(planetsProviderWidget),
          ),
        ),
      ),
    );
  }

  List<Widget> get createOrderedPlanetWidgets {
    List<Widget> orderedList = [];
    orderedList.addAll(Planets.leftCorner
        .map((e) => PlanetWidget(
              name: e,
              index: 3,
              controller: _controller,
            ))
        .toList());
    orderedList.addAll(Planets.rightCorner
        .map((e) => PlanetWidget(
              name: e,
              index: 1,
              controller: _controller,
            ))
        .toList());
    orderedList.addAll(Planets.back
        .map((e) => PlanetWidget(
              name: e,
              index: Planets.back.indexOf(e),
              controller: _controller,
            ))
        .toList());
    orderedList.addAll(Planets.front
        .map((e) => PlanetWidget(
              name: e,
              index: 1,
              controller: _controller,
            ))
        .toList());

    return orderedList;
  }
}


// class SolarSystemWhell extends ConsumerStatefulWidget {
//   const SolarSystemWhell({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _SolarSystemWhellState();
// }

// class _SolarSystemWhellState extends ConsumerState<SolarSystemWhell> {
//   final double _angle = 0.0;

//   @override
//   Widget build(BuildContext context) {
//     int numberOfPlanets = 8; // Exemplo com 8 planetas
//     double radius = 200; // Raio da roda
//     return GestureDetector(
//       onPanUpdate: (details) {},
//       child: SizedBox(
//         width: double.infinity,
//         height: double.infinity,
//         child: Stack(
//           alignment: Alignment.center,
//           children: List.generate(numberOfPlanets, (index) {
//             double theta = (2 * pi / numberOfPlanets) * index + _angle;

//             return Transform(
//               transform: Matrix4.identity()
//                 ..setEntry(3, 2, 0.001) // Adiciona perspectiva
//                 ..rotateX(pi / 4) // Inclinação
//                 ..translate((radius * 1.25) * sin(theta), radius * sin(theta)),
//               alignment: Alignment.center,
//               child: PlanetWidget(planetIndex: index),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
