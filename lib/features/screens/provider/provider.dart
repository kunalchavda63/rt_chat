import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';

import '../../onboarding/auth_sevice/suth_service.dart';

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
  RecentUsersNotifier() : super([]);

  // Called when message is sent
  void addOrMoveToTop(UserModel user) {
    // Remove if already exists
    state = [
      user,
      ...state.where((u) => u.uid != user.uid),
    ];
  }

  // Optional: remove
  void removeUser(String uid) {
    state = state.where((u) => u.uid != uid).toList();
  }

  // Optional: clear all
  void clear() {
    state = [];
  }
}
