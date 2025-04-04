import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_embedded.g.dart';

@Riverpod(keepAlive: true)
bool isAppEmbedded(Ref ref) {
  return Uri.base.queryParameters.containsKey('isEmbedded');
}
