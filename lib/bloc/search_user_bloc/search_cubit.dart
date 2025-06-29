import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';

part 'search_state.dart';
class SearchUserCubit extends Cubit<SearchUserState> {
  SearchUserCubit() : super(SearchUserLoading());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<UserModel> _users = [];

  DocumentSnapshot? _lastAllUserDoc;
  DocumentSnapshot? _lastSearchDoc;

  bool _hasMoreAllUsers = true;
  bool _hasMoreSearch = true;

  String _lastSearchQuery = '';

  // 🔍 Search by email
  Future<void> searchUser(String query, {bool isNewSearch = false}) async {
    if (!_hasMoreSearch && !isNewSearch) return;

    try {
      if (isNewSearch) {
        _lastSearchDoc = null;
        _hasMoreSearch = true;
        _users.clear();
        _lastSearchQuery = query;
        emit(SearchUserLoading());
      }

      // Order by email and search using prefix technique
      Query queryRef = _firestore
          .collection('users')
          .orderBy('email')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .limit(10);

      if (_lastSearchDoc != null && !isNewSearch) {
        queryRef = queryRef.startAfterDocument(_lastSearchDoc!);
      }

      final snapshot = await queryRef.get();
      final docs = snapshot.docs;

      if (docs.length < 10) _hasMoreSearch = false;
      if (docs.isNotEmpty) _lastSearchDoc = docs.last;

      final result = docs
          .where((doc) => doc.id != _auth.currentUser?.uid)
          .map((doc) => UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      _users.addAll(result);
      emit(SearchUserLoaded(List.from(_users)));
    } catch (e) {
      emit(SearchUserError(e.toString()));
    }
  }


  // 👥 All users list (default)
  Future<void> fetchAllUser({bool isNewSearch = false}) async {
    if (!_hasMoreAllUsers && !isNewSearch) return;

    try {
      if (isNewSearch) {
        _lastAllUserDoc = null;
        _hasMoreAllUsers = true;
        _users.clear();
        emit(SearchUserLoading());
      }

      Query queryRef = _firestore.collection('users').orderBy('uid').limit(10);

      if (_lastAllUserDoc != null && !isNewSearch) {
        queryRef = queryRef.startAfterDocument(_lastAllUserDoc!);
      }

      final snapshot = await queryRef.get();
      final docs = snapshot.docs;

      if (docs.length < 10) _hasMoreAllUsers = false;
      if (docs.isNotEmpty) _lastAllUserDoc = docs.last;

      final result = docs
          .where((doc) => doc.id != _auth.currentUser?.uid)
          .map((doc) => UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      _users.addAll(result);
      emit(SearchUserLoaded(List.from(_users)));
    } catch (e) {
      emit(SearchUserError(e.toString()));
    }
  }
}
