import 'package:cloud_firestore/cloud_firestore.dart';

class Scheduledto {
  final String id;
  final String packageId;
  final String title;
  final String content;
  final String imageUrl;
  final String order;


  Scheduledto({
    required this.id,
    required this.packageId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.order,
  });

  factory Scheduledto.fromJson(Map<String, dynamic> json) {
    return Scheduledto(
      id: json['id'] as String,
      packageId: json['packageId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
      order: json['order'] as String,
    );
  }

  get isHidden => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packageId': packageId,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'order': order,
    };
  }
}