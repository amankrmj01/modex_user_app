import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/order/order_bloc.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/restaurant_repository.dart';
import 'bloc/auth/auth_bloc.dart';
import 'presentation/screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => RestaurantRepository()),
        RepositoryProvider(create: (context) => OrderRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          BlocProvider(create: (context) => CartBloc()),
          BlocProvider(
            create: (context) => OrderBloc(
              orderRepository: RepositoryProvider.of<OrderRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mini Zomato',
          theme: ThemeData(primarySwatch: Colors.red),
          home: LoginScreen(),
        ),
      ),
    );
  }
}
