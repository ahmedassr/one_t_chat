abstract class LoginStates{}


class LoginInitialState extends LoginStates{}

class PasswordChangeVisibility extends LoginStates{}

class UserLoginLoading extends LoginStates{}

class UserLoginSuccess extends LoginStates{}

class UserLoginError extends LoginStates{
  final String error;
  UserLoginError(this.error);
}

