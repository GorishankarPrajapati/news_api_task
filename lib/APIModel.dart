class ApiDataModel {
  final String published;
  final String? title;

  final String? description;

  final String? imageUrl;
  ApiDataModel(
      {required this.published,
      required this.title,
      required this.description,
      required this.imageUrl});

  factory ApiDataModel.fromJson(Map json) {
    return ApiDataModel(
        published: json['publishedAt'],
        title: json['title'],
        description: json['description'],
        imageUrl: json["urlToImage"]);
  }
}
