class W {
  const W({
    this.name,
    this.categories,
    this.subcategories,
    this.description,
    this.link,
    this.image,
    this.sample,
  });
  final String name;
  final List<String> categories;
  final List<String> subcategories;
  final String description;
  final String link;
  final String image;
  final String sample;

  W.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        categories = (json['categories'] as List).cast(),
        subcategories = (json['subcategories'] as List).cast(),
        description = json['description'] as String,
        link = json['link'] as String,
        image = json['image'] as String,
        sample = json['sample'] as String;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is W && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
