import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationIndexMainScreenProvider =
    StateProvider.autoDispose<int>((ref) => 0);
final isLoadingMainScreenProvider =
    StateProvider.autoDispose<bool>((ref) => false);
