/// Central place for all app route names.
/// Keep these in sync with `RouteGenerator.generateRoute`.
class Routes {
  // ── Auth ────────────────────────────────────────────────────────────────────
  static const splash = '/splash  ';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const otp = '/otp';
  static const resetPassword = '/reset-password';

  // ── Home / Tabs ─────────────────────────────────────────────────────────────
  static const home = '/home';
  static const search = '/search';
  static const saved = '/saved';
  static const cart = '/cart';
  static const account = '/account';
  static const notifications = '/notifications';

  // ── Products ────────────────────────────────────────────────────────────────
  static const productDetails = '/product-details';
  static const reviews = '/reviews';
}
