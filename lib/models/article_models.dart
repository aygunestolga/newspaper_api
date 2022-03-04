import 'package:json_annotation/json_annotation.dart';

part 'article_models.g.dart';

@JsonSerializable(createToJson: false)
class Article{
  @JsonKey(defaultValue:'Unknown')
  final String author;
  final String ? title;
  final String ? description;
  final String ? url;
  @JsonKey(name:'urlToImage')
  final String ? imageUrl;
  final String ? publishedAt;
  final String ? content;
  final String ? source;

  Article(
      {
       required this.author,
       required this.title,
       required this.description,
       required this.url,
       required this.imageUrl,
       required this.publishedAt,
       required this.content,
       required this.source});

  factory Article.fromJson(Map<String, dynamic>json) => _$ArticleFromJson(json);
}

@JsonSerializable(createToJson: false)
class ArticleSource{
  final String ? name;
  final String ? id;

  ArticleSource(
      {required this.id,
        required this.name});

  factory ArticleSource.fromJson(Map<String, dynamic>json) => _$ArticleSourceFromJson(json);
}