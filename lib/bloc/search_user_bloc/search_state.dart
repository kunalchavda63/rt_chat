part of 'search_cubit.dart';

abstract class SearchUserState {}

class SearchUserLoading extends SearchUserState{}
class SearchUserLoaded extends SearchUserState{
    final List<UserModel> users;

    SearchUserLoaded(this.users);
}
class SearchUserError extends SearchUserState{
  final String message;
  SearchUserError(this.message);
}

