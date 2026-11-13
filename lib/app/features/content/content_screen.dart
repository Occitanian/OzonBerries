import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/models.dart';
import '../../../di/di.dart';
import 'bloc/content_bloc.dart';

class ContentScreen extends StatefulWidget {
  final int contentId;
  final Content? initialContent; // Для быстрого отображения локальных карточек

  const ContentScreen({
    super.key,
    required this.contentId,
    this.initialContent,
  });

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late final ContentBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<ContentBloc>();
    _bloc.add(
      LoadContent(id: widget.contentId, initialContent: widget.initialContent),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: BlocBuilder<ContentBloc, ContentState>(
        bloc: _bloc,
        builder: (context, state) {
          return switch (state) {
            ContentInitial() => const SizedBox.shrink(),
            ContentLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ContentLoaded() => _buildLoaded(state.content),
            ContentError() => Center(child: Text('Ошибка: ${state.message}')),
          };
        },
      ),
    );
  }

  Widget _buildLoaded(Content content) {
    final isNetwork = content.image.startsWith('http');

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ), // Ограничиваем ширину всего экрана
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // БЛОК С КАРТИНКОЙ
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: SizedBox(
                    width: 250, // Фиксированная ширина
                    height: 250, // Фиксированная высота (1:1)
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // Скругленные углы
                      child: isNetwork
                          ? Image.network(
                              content.image,
                              fit: BoxFit.contain, // contain показывает картинку целиком без обрезки
                              filterQuality: FilterQuality.high,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            )
                          : Image.asset(
                              content.image,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            ),
                    ),
                  ),
                ),
              ),
              // КОНЕЦ БЛОКА С КАРТИНКОЙ

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text(
                      content.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'Автор: ${content.author}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    Text(
                      'Цена: \$${content.price}',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(color: Colors.green),
                    ),

                    Text(
                      content.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              // Внутри метода _buildLoaded, в конце Column с текстами:
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: content.id < 0
                        ? Colors.green
                        : const Color(
                            0xFF005BFF,
                          ), // Синяя кнопка для товаров, зеленая для приюта
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    content.id < 0 ? 'Забрать домой' : 'Добавить в корзину',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: Colors.grey.shade300,
    child: const Icon(Icons.broken_image, size: 48),
  );
}
