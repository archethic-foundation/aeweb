import 'dart:developer';

import 'package:aeweb/model/hive/db_helper.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';

void setupServiceLocator() {
  aedappfm.sl.registerLazySingleton<DBHelper>(DBHelper.new);
}

void setupServiceLocatorApiService(String endpoint) {
  aedappfm.sl.registerLazySingleton<ApiService>(
    () => ApiService(endpoint, logsActivation: false),
  );
  log('Register', name: 'ApiService');
  aedappfm.sl.registerLazySingleton<OracleService>(
    () => OracleService(endpoint, logsActivation: false),
  );
  log('Register', name: 'OracleService');
}
