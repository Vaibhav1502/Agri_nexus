import 'package:agri_nexus_ht/app/data/models/role_selection/role_selection_view.dart';
import 'package:agri_nexus_ht/app/modules/cart/cart_view.dart';
import 'package:agri_nexus_ht/app/modules/categories/all_categories_view.dart';
import 'package:agri_nexus_ht/app/modules/checkout/checkout_view.dart';
import 'package:agri_nexus_ht/app/modules/home/category_detail_view.dart';
import 'package:agri_nexus_ht/app/modules/home/home_view.dart';
import 'package:agri_nexus_ht/app/modules/home/main_home_view.dart';
import 'package:agri_nexus_ht/app/modules/orders/order_detail_view.dart';
import 'package:agri_nexus_ht/app/modules/product_detail/product_detail_view.dart';
import 'package:agri_nexus_ht/app/modules/splash/splash_view.dart';
import 'package:agri_nexus_ht/app/modules/subcategories/subcategory_detail_view.dart';
import 'package:get/get.dart';
import '../modules/login/login_view.dart';
import '../modules/register/register_view.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const roleSelection = '/role-selection';
  static const home = '/home';
  static const productDetail = '/product-detail';
  static const categoryDetail = '/category-detail';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orderDetail = '/order-detail';
  static const allCategories = '/all-categories';
  static const subcategoryDetail = '/subcategory-detail';
}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => SplashView()),
     GetPage(name: AppRoutes.roleSelection, page: () => const RoleSelectionView()),
    GetPage(name: AppRoutes.login, page: () => LoginView()),
    GetPage(name: AppRoutes.register, page: () => RegisterView()),
    GetPage(name: AppRoutes.home, page: () => MainHomeView()),
    GetPage(name: AppRoutes.orderDetail, page: () => const OrderDetailView()),
    GetPage(name: AppRoutes.allCategories, page: () => const AllCategoriesView()),
    GetPage(name: AppRoutes.subcategoryDetail, page: () => SubcategoryDetailView()),
    GetPage(
      name: '/product-detail',
      page: () => ProductDetailView(productId: Get.arguments),
    ),
    GetPage(name: AppRoutes.categoryDetail, page: () => CategoryDetailView()),
    GetPage(name: AppRoutes.cart, page: () => CartView()),
    GetPage(name: AppRoutes.checkout, page: () => const CheckoutView()),
  ];
}
