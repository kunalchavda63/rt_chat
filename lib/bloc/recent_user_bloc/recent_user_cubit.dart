// recent_user_cubit.dart
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'recent_user_state.dart';

class RecentUserCubit extends Cubit<RecentUserState> {
  RecentUserCubit() : super(RecentUserInitial()) {
    _loadFromPrefs();
  }

  final String _key = 'recent_chats';

  void addOrMoveToTop(UserModel user) {
    final updatedList = [
      user,
      ..._getCurrentUsers().where((u) => u.uid != user.uid),
    ];
    emit(RecentUserLoaded(updatedList));
    _savePrefs(updatedList);
  }

  void removeUser(String uid) {
    final updatedList = _getCurrentUsers().where((u) => u.uid != uid).toList();
    emit(RecentUserLoaded(updatedList));
    _savePrefs(updatedList);
  }

  void clear() {
    emit(RecentUserLoaded([]));
    _savePrefs([]);
  }

  Future<void> _savePrefs(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  Future<void> _loadFromPrefs() async {
    try {
      emit(RecentUserLoading());
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_key) ?? [];
      final userList = jsonList
          .map((userStr) => UserModel.fromJson(jsonDecode(userStr)))
          .toList();
      emit(RecentUserLoaded(userList));
    } catch (e) {
      emit(RecentUserError('Failed to load recent users'));
    }
  }

  List<UserModel> _getCurrentUsers() {
    if (state is RecentUserLoaded) {
      return (state as RecentUserLoaded).users;
    }
    return [];
  }
}
