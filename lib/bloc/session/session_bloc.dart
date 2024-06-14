import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/repositories/user_repository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final UserRepository userRepository;

  SessionBloc(this.userRepository) : super(SessionInitial()) {
    on<SessionEvent>((event, emit) {});

    on<FetchCurrentSession>((event, emit) {
      emit(SessionLoading(isLoading: true));
      try {
        final SessionModel? sessionData= userRepository.sessionDataModel;
        if(sessionData!= null){
          emit(SessionSuccessState(sessionData: sessionData));
        }else{
          emit(SessionErrorState(errorMessage: 'Error Loading session'));
        }
        
      }on FirebaseException catch (e) {
         print('get error in sesssion');
        print(e.toString());
      }
    });
  }
}
