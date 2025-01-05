abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class ChangeSignInPasswordVisibility extends RegisterStates{}

class UserRegisterLoading extends RegisterStates {}

class UserRegisterSuccess extends RegisterStates {}

class UserRegisterError extends RegisterStates {
  final String error;

  UserRegisterError(this.error);
}

class UserCreateLoading extends RegisterStates {}

class UserCreateSuccess extends RegisterStates {}

class UserCreateError extends RegisterStates {
  final String error;

  UserCreateError(this.error);
}
