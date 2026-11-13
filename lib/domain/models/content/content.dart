import 'package:json_annotation/json_annotation.dart';

part 'content.g.dart';

@JsonSerializable()
class Content {
  final int id;
  final String title;

  @JsonKey(name: 'brand', defaultValue: 'Без бренда')
  final String author;

  final String description;

  @JsonKey(name: 'thumbnail', defaultValue: '')
  final String image;

  final double price;

  const Content({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.image,
    required this.price,
  });

  factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);
  Map<String, dynamic> toJson() => _$ContentToJson(this);
}