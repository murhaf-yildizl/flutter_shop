part of 'user_bloc.dart';

@immutable
abstract class UserState {
  User? user;

  UserState(this.user);
}

class GetUserState extends UserState {

  GetUserState(User? user) : super(user);

}


class UserIsLoadingState extends UserState {

  UserIsLoadingState() : super(null);

}


class UserErrorState extends UserState {
    String error;
  UserErrorState(this.error) : super(null);

}