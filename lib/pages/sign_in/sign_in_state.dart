abstract class SignInState {}

class SignInStateInitial extends SignInState {}

class SignInStateLoading extends SignInState {}

class SignInStateSucess extends SignInState {}

class SignInStateError extends SignInState {
  final String message;
  SignInStateError({required this.message});
}
