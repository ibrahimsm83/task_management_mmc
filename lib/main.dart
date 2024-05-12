import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagment/data/web_services/internet/internet_cubit.dart';
import 'package:taskmanagment/firebase_options.dart';
import 'package:taskmanagment/pages/bloc/task_bloc.dart';
import 'package:taskmanagment/pages/tasks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetCubit>(create: (context) => InternetCubit()),
        BlocProvider<TaskManagementBloc>(create: (context) => TaskManagementBloc()),
      ],

      child: MaterialApp(
        title: 'Task Management',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TaskScreen(),
        //const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
