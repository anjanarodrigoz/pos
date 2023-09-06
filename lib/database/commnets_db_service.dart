import 'package:get_storage/get_storage.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/utils/val.dart';

class CommentsDB {
  final _storage = GetStorage(DBVal.comments);
  static final CommentsDB _instance = CommentsDB._internal();

  factory CommentsDB() {
    return _instance;
  }

  CommentsDB._internal();

  Future<void> addComments(Comment comment) async {
    await _storage.write(comment.name, comment.toJson());
  }

  Future<List<Comment>> readAllComments() async {
    List comentList = await _storage.getValues().toList() ?? [];

    return comentList.map((comment) => Comment.fromJson(comment)).toList();
  }

  Future<Comment> getComment(String name) async {
    var json = await _storage.read(name);
    return Comment.fromJson(json);
  }

  Future<void> deleteComment(String name) async {
    await _storage.remove(name);
  }
}

class Comment {
  String name;
  String comment;

  Comment({required this.name, required this.comment});

  Map toJson() {
    return {
      'name': name,
      'comment': comment,
    };
  }

  // Create a Comment object from a JSON map
  factory Comment.fromJson(json) {
    return Comment(
      name: json['name'] as String,
      comment: json['comment'] as String,
    );
  }
}
