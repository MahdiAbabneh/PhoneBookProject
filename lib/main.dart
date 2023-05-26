import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Layout/Home/cubit/cubit.dart';
import 'Layout/Home/cubit/states.dart';
import 'Layout/Home/home_screen.dart';
import 'bloc_observer.dart';


void main() {
  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => HomeCubit()..getContacts()),
      ],
      child: BlocConsumer<HomeCubit,HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return  const MaterialApp(
            title: "Contact Information",
            debugShowCheckedModeBanner: false,
            home:HomeScreen(),
          );
        },
      ),
    );
  }
}
