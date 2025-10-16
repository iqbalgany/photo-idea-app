import 'package:fd_log/fd_log.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

initInjection() {
  FDLog fdLog = FDLog(
    bodyColorCode: 49,
    titleColorCode: 50,
    maxCharPerRow: 70,
    maxRow: 5,
    prefix: '>',
  );
  sl.registerLazySingleton(() => fdLog);
}
