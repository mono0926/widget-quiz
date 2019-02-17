class W {
  W({
    this.name,
    this.desc,
    this.link,
    this.image,
  });

  final String name;
  final String desc;
  final String link;
  final String image; // TODO: 使用しないなら消す

  W.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        desc = json['description'] as String,
        link = json['link'] as String,
        image = json['image'] as String;
}
