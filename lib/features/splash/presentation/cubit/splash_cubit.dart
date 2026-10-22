import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

/// Coordinates splash screen initialization and the transition to Home.
///
/// Responsibilities:
/// - Begin the animation sequence.
/// - Perform any required async initialization (e.g., theme/locale loading,
///   which are handled by ThemeCubit and LocaleCubit, not here).
/// - Signal completion so the SplashScreen can navigate to Home.
/// - Ensure the user cannot get stuck if initialization fails.
final class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  /// Start the splash sequence.
  /// The minimum display time covers the animation duration.
  /// [onInitializationComplete] is an optional async callback for any
  /// initialization work that must complete before navigating.
  Future<void> start({
    Future<void> Function()? onInitializationComplete,
  }) async {
    if (state is! SplashInitial) return;
    emit(const SplashAnimating());

    try {
      // Allow the animation to run for a pleasant reveal duration.
      // 3.2 s covers Stages A-D of the animation sequence.
      const animationDuration = Duration(milliseconds: 3200);

      await Future.wait([
        Future<void>.delayed(animationDuration),
        if (onInitializationComplete != null) onInitializationComplete(),
      ]);

      if (!isClosed) emit(const SplashComplete());
    } catch (_) {
      // Even on failure, transition to home — never leave the user stuck.
      if (!isClosed) emit(const SplashComplete());
    }
  }
}
