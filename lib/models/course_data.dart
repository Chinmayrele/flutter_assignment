final String tableNotes = "course";

class CourseFields {
  static final List<String> values = [
    id,
    name,
    description,
    language,
    watchersCount,
    stargazerCount
  ];

  static final String id = "_id";
  static final String name = "name";
  static final String description = "description";
  static final String language = "language";
  static final String watchersCount = "watchersCount";
  static final String stargazerCount = "stargazerCount";
}

class CourseData {
  int id;
  String name;
  String description;
  String language;
  int watchersCount;
  int stargazerCount;

  CourseData({
    required this.id,
    required this.name,
    required this.description,
    required this.language,
    required this.watchersCount,
    required this.stargazerCount,
  });

  CourseData copy({
    int? id,
    String? name,
    String? description,
    String? language,
    int? watchersCount,
    int? stargazerCount,
  }) =>
      CourseData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        language: language ?? this.language,
        watchersCount: watchersCount ?? this.watchersCount,
        stargazerCount: stargazerCount ?? this.stargazerCount,
      );

  Map<String, Object?> toJson() => {
        CourseFields.id: id,
        CourseFields.name: name,
        CourseFields.description: description,
        CourseFields.language: language,
        CourseFields.watchersCount: watchersCount,
        CourseFields.stargazerCount: stargazerCount,
      };

  static CourseData fromJson(Map<String, Object?> json) => CourseData(
      id: json[CourseFields.id] as int,
      name: json[CourseFields.name] as String,
      description: json[CourseFields.description] as String,
      language: json[CourseFields.language] as String,
      watchersCount: json[CourseFields.watchersCount] as int,
      stargazerCount: json[CourseFields.stargazerCount] as int);
}
