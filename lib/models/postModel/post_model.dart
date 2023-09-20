import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String userId;
  final String content;
  final Timestamp timestamp;

  PostModel({
    required this.userId,
    required this.content,
    required this.timestamp,
  });
  PostModel.fromMap(Map<String, dynamic> map)
      : userId = map['uid'],
        content = map['content'],
        timestamp = map['timestamp'];

  Map<String, dynamic> toJson() => {
    'uid': userId,
    'content' : content,
    'timestamp' : timestamp,
  };

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      userId: snapshot['userId'],
      content: snapshot['content'],
      timestamp: snapshot['timestamp'],
    );
  }
}
