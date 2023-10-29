import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoadingWelcomeScreenProvider =
    StateProvider.autoDispose<bool>((ref) => false);
