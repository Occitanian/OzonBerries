import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../data/data.dart';
import '../domain/domain.dart';
import '../app/features/home/bloc/home_bloc.dart';
import '../app/features/content/bloc/content_bloc.dart';

final getIt = GetIt.instance;
final talker = TalkerFlutter.init();
final dio = Dio();

Future<void> setupLocator() async {
  getIt.registerSingleton(talker);
  setUpDio();

  getIt.registerSingleton<ContentRepositoryInterface>(
    ContentRepository(dio: dio),
  );
  getIt.registerSingleton(
    HomeBloc(getIt.get<ContentRepositoryInterface>()),
  );
  
  // Добавляем фабрику для ContentBloc
  getIt.registerFactory<ContentBloc>(
    () => ContentBloc(getIt.get<ContentRepositoryInterface>()),
  );
}