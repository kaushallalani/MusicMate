import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/repositories/firebase_repository.dart';

import '../../../repositories/user_repository.dart';
import '../../../services/auth.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UserRepository userRepository;
  final FirebaseRepository firebaseRepository;

  final AuthenticationService authenticationService = AuthenticationService();
  DashboardBloc(this.userRepository, this.firebaseRepository)
      : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {});

    on<FetchUserDataFromFirebase>((event, emit) async {
      emit(DashboardLoadingState(isLoading: true));
      try {
        final UserModel? userData = await firebaseRepository.getCurrentUser();
        if (userData != null) {
          userRepository.saveUserData(userData);
          emit(
              DashboardSuccessState(currentUser: userRepository.userDataModel));
        } else {
          emit(DashboardFailureState(
              errorMessage: 'Error fetching userdetails'));
        }
        emit (DashboardLoadingState(isLoading: false));
      } catch (e) {}
    });

    on<GetUserDetails>((event, emit) async {
      print('event called');
      emit(DashboardLoadingState(isLoading: true));
      try {
        final userData = userRepository.userDataModel;
        Logger().d(userData);
        if (userData != null) {
          emit(DashboardSuccessState(currentUser: userData));
        } else {
          emit(DashboardFailureState(
              errorMessage: 'Error fetching userdetails'));
        }

        // final String userId = await authenticationService.getCurrentUserId();
        // if (userId != null) {
        //   final UserModel userDetails =
        //       await authenticationService.userDetailsGet(id: userId);

        //   if (userDetails != null) {
        //     emit(DashboardSuccessState(currentUser: userDetails));
        //   } else {
        //     emit(DashboardFailureState(
        //         errorMessage: 'Error fetching userdetails'));
        //   }

        emit(DashboardLoadingState(isLoading: false));
      } on Exception catch (e) {
        print('get error');
        print(e.toString());
      }
    });
  }
}
