/// The lifecycle stages of the splash screen initialization.
sealed class SplashState {
  const SplashState();
}

/// Initial state — animation sequence has not yet begun.
final class SplashInitial extends SplashState {
  const SplashInitial();
}

/// The animation sequence is running.
final class SplashAnimating extends SplashState {
  const SplashAnimating();
}

/// Initialization is complete — the screen may transition to home.
final class SplashComplete extends SplashState {
  const SplashComplete();
}

/// An unrecoverable error occurred during initialization.
/// The splash screen must still transition to avoid the user getting stuck.
final class SplashError extends SplashState {
  const SplashError({required this.message});
  final String message;
}
