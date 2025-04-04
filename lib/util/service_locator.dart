import 'package:aeweb/model/hive/db_helper.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;

void setupServiceLocator() {
  aedappfm.sl.registerLazySingleton<DBHelper>(DBHelper.new);
}
