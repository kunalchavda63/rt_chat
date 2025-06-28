part of 'recent_user_cubit.dart';

abstract class RecentUserState {}

class RecentUserInitial extends RecentUserState{}
class RecentUserLoading extends RecentUserState{}
class RecentUserLoaded extends RecentUserState{
  final List<UserModel> users;
  RecentUserLoaded(this.users);
}
class RecentUserError extends RecentUserState{
  final String message;
  RecentUserError(this.message);
}
