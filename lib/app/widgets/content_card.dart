import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/models/models.dart';

class ContentCard extends StatelessWidget {
  final Content content;
  const ContentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    const imageSize = 100.0;

    // 🔹 Определяем, откуда грузить картинку
    final isNetwork = content.image.startsWith('http');

    return InkWell(
      onTap: () => context.push('/content/${content.id}', extra: content),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: imageSize,
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: isNetwork
                  ? Image.network(
                      content.image,
                      height: imageSize,
                      width: imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(imageSize),
                    )
                  : Image.asset(
                      content.image,
                      height: imageSize,
                      width: imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(imageSize),
                    ),
            ),
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Expanded(
                    child: Text(
                      content.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(double size) => Container(
        height: size,
        width: size,
        color: Colors.grey,
        child: const Icon(Icons.broken_image, color: Colors.white),
      );
}