import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


final searchUserProvider =
    StateNotifierProvider<SearchUserNotifier, AsyncValue<List<UserModel>>>(
      (ref) => SearchUserNotifier(),
    );


class SearchUserNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  SearchUserNotifier() : super(const AsyncLoading());

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  final List<UserModel> _users = [];

  Future<void> searchUsers(String query, {bool isNewSearch = true}) async {
    if (!_hasMore && !isNewSearch) return;

    try {
      if (isNewSearch) {
        _lastDoc = null;
        _users.clear();
        _hasMore = true;
        state = const AsyncLoading();
      }

      Query queryRef = _firestore
          .collection('users')
          .orderBy('email')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .limit(10);

      if (_lastDoc != null && !isNewSearch) {
        queryRef = queryRef.startAfterDocument(_lastDoc!);
      }

      final snapshot = await queryRef.get();
      final docs = snapshot.docs;

      if (docs.length < 10) _hasMore = false;
      if (docs.isNotEmpty) _lastDoc = docs.last;

      final results =
          docs
              .where((doc) => doc.id != _auth.currentUser?.uid)
              .map(
                (doc) => UserModel.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList();

      _users.addAll(results);
      state = AsyncData(_users);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  Future<void> fetchAllUsers({bool isNewSearch = true}) async {
    if (!_hasMore && !isNewSearch) return;

    try {
      if (isNewSearch) {
        _lastDoc = null;
        _users.clear();
        _hasMore = true;
        state = const AsyncLoading();
      }

      Query queryRef = _firestore
          .collection('users')
          .orderBy('uid')
          .limit(10);

      if (_lastDoc != null && !isNewSearch) {
        queryRef = queryRef.startAfterDocument(_lastDoc!);
      }

      final snapshot = await queryRef.get();
      final docs = snapshot.docs;

      if (docs.length < 10) _hasMore = false;
      if (docs.isNotEmpty) _lastDoc = docs.last;

      final results = docs
          .where((doc) => doc.id != _auth.currentUser?.uid)
          .map(
            (doc) => UserModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ),
      )
          .toList();

      _users.addAll(results);
      state = AsyncData(_users);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

}

final recentUsersProvider = StateNotifierProvider<RecentUsersNotifier, List<UserModel>>(
      (ref) => RecentUsersNotifier(),
);
class RecentUsersNotifier extends StateNotifier<List<UserModel>> {
  RecentUsersNotifier() : super([]) {
    _loadFromPrefs();
  }

  final String _key = 'recent_chats';

  /// Add or move user to top of list
  void addOrMoveToTop(UserModel user) {
    state = [
      user,
      ...state.where((u) => u.uid != user.uid),
    ];
    _savePrefs();
  }

  /// Remove a user by uid
  void removeUser(String uid) {
    state = state.where((u) => u.uid != uid).toList();
    _removeFromPrefs(uid);
  }

  /// Clear all recent chats
  void clear() {
    state = [];
    _savePrefs(); // Clear from SharedPreferences too
  }

  /// Save list to SharedPreferences
  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  /// Load recent users from SharedPreferences
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    state = jsonList
        .map((userStr) => UserModel.fromJson(jsonDecode(userStr)))
        .toList();
  }

  /// Remove one user from SharedPreferences only (called internally)
  Future<void> _removeFromPrefs(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    final updatedUsers = jsonList
        .map((user) => UserModel.fromJson(jsonDecode(user)))
        .where((user) => user.uid != uid)
        .toList();

    final newJsonList =
    updatedUsers.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList(_key, newJsonList);
  }
}