import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

// Provider untuk scroll ke section chart tertentu saat tap sensor card
// 0=none, 1=temperature, 2=humidity, 3=soil, 4=light
final chartScrollTargetProvider = StateProvider<int>((ref) => 0);
