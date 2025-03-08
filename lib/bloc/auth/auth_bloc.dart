import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState(null)) {
    on<AuthUserChanged>((event, emit) {
      emit(AuthState(event.user));
    });
  }
}
