import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
abstract class TodoModel with _$TodoModel {
  const factory TodoModel({
    required String id,
    required String title,
    required String desc,
    required DateTime time,
    required bool isCompleted,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
}

extension TodoModelSqlite on TodoModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'time': time.millisecondsSinceEpoch, // DateTime → int
      'isCompleted': isCompleted ? 1 : 0, // bool → int
    };
  }

  static TodoModel fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      desc: map['desc'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
