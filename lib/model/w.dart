class W {
  W({
    this.name,
    this.desc,
    this.link,
  });

  final String name;
  final String desc;
  final String link;

  W.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        desc = json['description'],
        link = json['link'];
}
