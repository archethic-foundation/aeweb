/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final versionStringProvider = FutureProvider.autoDispose
    .family<String, AppLocalizations>((ref, localizations) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return '${localizations.version} ${packageInfo.version} - ${localizations.build} ${packageInfo.buildNumber}';
});
