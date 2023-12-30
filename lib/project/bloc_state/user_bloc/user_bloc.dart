import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/api.dart';
import '../../mvc/1.model/customer/User.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  late   User user;

  UserBloc() : super(GetUserState(null)) {

    on<UserEvent>((event, emit)async {
     if(event is GetUserEvent)
    {
     // emit(UserIsLoadingState());
      final res = await getData('getuser', 'authenticated') ;
     if (res != null )
       if(res.length>0)
      {
         user=User.fromJson(res);

        emit(GetUserState(this.user));
      }

   else  emit(UserErrorState("user not fount"));

    }
    
     });

  }
}
