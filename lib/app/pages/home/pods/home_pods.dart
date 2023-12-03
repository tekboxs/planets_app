import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorProvider = StateProvider.family<Color, int>((ref, id) {
  return Colors.amber;
});

final planetsProvider = StateProvider<List<String>>((ref) {
  return [];
});
final planetsProviderWidget = StateProvider<List<Widget>>((ref) {
  return [];
});

final angleProvider = StateProvider<int>((ref) {
  return 0;
});


 
// void moveCentralItem(int direction) {
//     if (state.isEmpty) return;

//     final tempList = List<Widget>.from(state);

//     if (direction > 0) {
//       var lastItem = tempList.removeLast();
//       tempList.insert(0, lastItem);
//     } else if (direction < 0) {
//       var firstItem = tempList.removeAt(0);
//       tempList.add(firstItem);
//     }

//     state = tempList; // Atualiza o estado com a nova lista
//   }
//

  