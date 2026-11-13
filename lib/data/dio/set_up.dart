import 'package:talker_dio_logger/talker_dio_logger.dart';
import '../../di/di.dart';

void setUpDio() {
  // Указываем локальный адрес прокси
  dio.options.baseUrl = 'http://localhost:8080/api';
  dio.options.connectTimeout = const Duration(seconds: 15);

  dio.options.baseUrl = 'https://dummyjson.com'; 
  dio.options.connectTimeout = const Duration(seconds: 20);
  dio.options.receiveTimeout = const Duration(seconds: 20);

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