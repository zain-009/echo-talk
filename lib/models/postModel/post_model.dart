import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String name;
  final String content;
  final DateTime timestamp;

  PostModel({
    required this.name,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory PostModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return PostModel(
      name: data['name'],
      content: data['content'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}