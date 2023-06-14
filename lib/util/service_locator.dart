import 'dart:developer';

import 'package:aeweb/model/hive/db_helper.dart';
import 'package:aeweb/util/generic/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';

void setupServiceLocator() {
  sl.registerLazySingleton<DBHelper>(DBHelper.new);
}

void setupServiceLocatorApiService(String endpoint) {
  sl.registerLazySingleton<ApiService>(
    () => ApiService(endpoint),
  );
  log('Register', name: 'ApiService');
}
