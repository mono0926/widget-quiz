class W {
  W({
    this.name,
    this.desc,
    this.link,
  });

  final String name;
  final String desc;
  final String link;

  W.fromJson(Map<String, dynamic> j)
      : name = j['name'],
        desc = j['description'],
        link = j['link'];
}
