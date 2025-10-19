abstract class SignUpState {}

class SignUpLoadingState extends SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpSuccessState extends SignUpState {}

class SignUpErrorState extends SignUpState {
  final String message;

  SignUpErrorState({required this.message});
}
