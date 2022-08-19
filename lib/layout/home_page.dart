import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_murf/shared/cubit/app_cubit.dart';

import '../shared/cubit/app_states.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
          builder: (BuildContext context, state) {
            return Scaffold(
              body: AppCubit.get(context)
                  .screens[AppCubit.get(context).currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.create), label: 'Create'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.qr_code), label: 'Scan'),
                ],
                onTap: (index) {
                  AppCubit.get(context).changeBottomNavBar(index);
                },
                currentIndex: AppCubit.get(context).currentIndex,
              ),
            );
          },
          listener: (BuildContext context, state) {}),
    );
  }
}
