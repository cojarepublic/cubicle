import 'package:cubicle/providers/auth.dart';
import 'package:cubicle/providers/cart.dart';
import 'package:cubicle/screens/auth_screen.dart';
import 'package:cubicle/screens/cart_screen.dart';
import 'package:cubicle/screens/edit_product_screen.dart';
import 'package:cubicle/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cubicle/providers/products.dart';
import 'package:cubicle/screens/product_detail_screen.dart';
import 'package:cubicle/screens/products_overview_screen.dart';

import 'providers/orders.dart';
import 'screens/orders_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            builder: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            builder: (ctx, auth, previousProducts) => Products(auth.token, auth.userId, previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider(
            builder: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            builder: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId, previousOrders == null ? [] : previousOrders.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Cubicle',
            theme: ThemeData(
                primarySwatch: Colors.orange,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                fontFamily: 'Righteous'),
            home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
