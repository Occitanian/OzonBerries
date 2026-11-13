import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/models/models.dart';

class ProductCard extends StatelessWidget {
  final Content content;
  const ProductCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/content/${content.id}', extra: content),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  content.image,
                  width: double.infinity,
                  fit: BoxFit.contain, // Товары лучше вписывать целиком
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${content.price.toStringAsFixed(2)} \$', 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFF91155)), // Красный цвет цены как в Ozon
                  ),
                  const SizedBox(height: 4),
                  Text(content.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text('4.${5 + content.id % 5} (${content.id * 100 + content.id % 5})', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}