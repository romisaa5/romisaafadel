import 'package:go_router/go_router.dart';
import 'routes.dart';
import '../../features/home/presentation/screens/home_screen.dart';

/// Central router configuration using go_router.
/// Directly loads the HomeScreen on startup. Pre-render startup splash is handled
/// natively by flutter_native_splash in web/index.html.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/home',
      redirect: (_, _) => AppRoutes.home,
    ),
  ],
);
