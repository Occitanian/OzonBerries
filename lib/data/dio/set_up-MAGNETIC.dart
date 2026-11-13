import 'package:talker_dio_logger/talker_dio_logger.dart';
import '../../di/di.dart';

void setUpDio() {
  dio.options.baseUrl = 'https://api.escuelajs.co/api/v1'; 
  dio.options.connectTimeout = const Duration(seconds: 15);
  dio.options.receiveTimeout = const Duration(seconds: 15);

  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestData: true,
        printRequestHeaders: true,
      ),
    ),
  );
}