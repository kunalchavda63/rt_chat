import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rt_chat/core/models/src/user_model/user_model.dart';

part 'search_state.dart';

class SearchUserCubit extends Cubit<SearchUserState>{
  SearchUserCubit() : super(SearchUserLoading());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<UserModel> _users = [];
  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;

  Future<void> searchUser(String query,{bool isNewSearch = false}) async{
    if(!_hasMore&& !isNewSearch)return;
    try{
      if(isNewSearch){
        _lastDoc = null;
        _users.clear();
        _hasMore = true;
        emit(SearchUserLoading());
      }
      Query queryRef = _firestore
      .collection('users')
      .orderBy('email')
      .startAt([query])
      .endAt(['$query\uf8ff'])
      .limit(10);
      if(_lastDoc != null && !isNewSearch){
        queryRef = queryRef.startAfterDocument(_lastDoc!);
      }
      final snapshot = await queryRef.get();
      final docs = snapshot.docs;
      if(docs.length<10) _hasMore = false;
      if(docs.isNotEmpty)_lastDoc = docs.last;
      final result = docs.where((doc) =>doc.id != _auth.currentUser?.uid)
      .map((doc) => UserModel.fromFirestore(doc.data() as Map<String,dynamic>, doc.id)).toList();
    _users.addAll(result);
    emit(SearchUserLoaded(List.from(_users)));
    } catch (e){
      emit(SearchUserError(e.toString()));
    }
  }
  Future<void> fetchAllUser({bool isNewSearch = true}) async{
    if(!_hasMore && !isNewSearch)return;

    try{
      if(isNewSearch){
        _lastDoc = null;
        _users.clear();
        _hasMore = true;
        emit(SearchUserLoading());
      }
      Query queryRef = _firestore
      .collection('users')
      .orderBy('uid')
      .limit(10);

      if(_lastDoc != null && !isNewSearch){
        queryRef = queryRef.startAfterDocument(_lastDoc!);
      }
      final snapshot = await queryRef.get();
      final docs = snapshot.docs;

      if(docs.length<10) _hasMore = false;
      if(docs.isNotEmpty) _lastDoc = docs.last;
      final result = docs
      .where((doc) => doc.id != _auth.currentUser?.uid)
      .map((doc) => UserModel.fromFirestore(doc.data() as Map<String,dynamic>, doc.id))
      .toList();
      _users.addAll(result);
      emit(SearchUserLoaded(List.from(_users)));
    } catch (e){
      emit(SearchUserError(e.toString()));
    }
  }



}