class ItemType {
  final int id;
  final String title;
  final String author;
  final String? gendre;

  ItemType({
    required this.id,
    required this.title,
    required this.author,
    this.gendre,
  });

  factory ItemType.fromJson(Map<String, dynamic> json) {
    return ItemType(
      id: json["id"],
      title: json["title"],
      author: json["author"],
      gendre: json["gendre"],
    );
  }
}
