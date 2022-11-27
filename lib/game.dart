class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String shortDescription;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;

  const Game(
      {required this.id,
      required this.title,
      required this.thumbnail,
      required this.shortDescription,
      required this.genre,
      required this.platform,
      required this.publisher,
      required this.developer,
      required this.releaseDate});

  static Game fromJson(json) => Game(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      shortDescription: json['short_description'],
      genre: json['genre'],
      platform: json['platform'],
      publisher: json['publisher'],
      developer: json['developer'],
      releaseDate: json['release_date']);
}
