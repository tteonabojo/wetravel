class Schedule {
  final String id;
  final String packageId;
  final String title;
  final String? content;
  final String? imageUrl;
  final int order;

  Schedule({
    required this.id,
    required this.packageId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.order,
  });
}
