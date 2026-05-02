// lib/core/routes/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/shopping_lists/shopping_lists_screen.dart';
import '../../screens/shop/shop_screen.dart';
import '../../screens/create_edit_list/create_edit_list_screen.dart';
import '../../screens/list_detail/list_detail_screen.dart';
import '../../screens/price_comparison/price_comparison_screen.dart';
import '../../screens/product_detail/product_detail_screen.dart';
import '../../screens/price_tracker/price_tracker_screen.dart';
import '../../screens/store_deals/store_deals_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/auth/login_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String lists = '/lists';
  static const String shop = '/shop';
  static const String createList = '/lists/create';
  static const String editList = '/lists/edit';
  static const String listDetail = '/lists/:id';
  static const String priceComparison = '/lists/:id/compare';
  static const String productDetail = '/products/:id';
  static const String tracker = '/tracker';
  static const String deals = '/deals';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String login = '/login';

  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: splash,
      routes: [
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: lists,
          name: 'lists',
          builder: (context, state) => const ShoppingListsScreen(),
        ),
        GoRoute(
          path: shop,
          name: 'shop',
          builder: (context, state) => const ShopScreen(),
        ),
        GoRoute(
          path: createList,
          name: 'createList',
          builder: (context, state) => const CreateEditListScreen(),
        ),
        GoRoute(
          path: editList,
          name: 'editList',
          builder: (context, state) {
            final listId = state.extra as String?;
            return CreateEditListScreen(listId: listId);
          },
        ),
        GoRoute(
          path: listDetail,
          name: 'listDetail',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ListDetailScreen(listId: id);
          },
        ),
        GoRoute(
          path: priceComparison,
          name: 'priceComparison',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return PriceComparisonScreen(listId: id);
          },
        ),
        GoRoute(
          path: productDetail,
          name: 'productDetail',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ProductDetailScreen(productId: id);
          },
        ),
        GoRoute(
          path: tracker,
          name: 'tracker',
          builder: (context, state) => const PriceTrackerScreen(),
        ),
        GoRoute(
          path: deals,
          name: 'deals',
          builder: (context, state) => const StoreDealsScreen(),
        ),
        GoRoute(
          path: notifications,
          name: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: profile,
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: search,
          name: 'search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: cart,
          name: 'cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
      ],
    );
  }
}
