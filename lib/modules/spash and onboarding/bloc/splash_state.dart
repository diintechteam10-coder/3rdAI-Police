abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashCompleted extends SplashState {
  final String nextRoute;
  final Map<String, dynamic>? arguments;

  SplashCompleted({required this.nextRoute, this.arguments});
}
