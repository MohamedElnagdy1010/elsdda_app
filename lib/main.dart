import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/core/dependency_injection/dependency_injection.dart';
import 'package:sufra_app/features/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:sufra_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:sufra_app/splashview.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(create: (_) => CartCubit()),
        BlocProvider<FavoritesCubit>(
          create: (_) {
            final cubit = getIt<FavoritesCubit>();
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              cubit.loadFavorites(user.uid);
            }

            return cubit;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sufra App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffB60F1A)),
      ),
      home: const SplashView(),
    );
  }
}
