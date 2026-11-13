import 'package:dio/dio.dart';
import '../../../data/data.dart';
import '../../models/content/content.dart';
import 'content_repository_interface.dart';

class ContentRepository implements ContentRepositoryInterface {
  ContentRepository({required this.dio});

  final Dio dio;

  @override
  Future<List<Content>> getContent() async {
    try {
      final response = await dio.get(Endpoints.content).timeout(const Duration(seconds: 15));
      
      // Извлекаем список из ключа 'products'
      final content = (response.data['products'] as List)
          .map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList();
          
      return content;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<Content> getContentById(int id) async {
    try {
      final response = await dio.get(Endpoints.contentById(id)).timeout(const Duration(seconds: 15));
      
      // Здесь API возвращает сразу объект, без обертки
      return Content.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw e.toString();
    }
  }
}