import 'package:employee_management/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/employee_cubit.dart';
import 'core/theme.dart';
import 'data/database.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.applySystemOverlay();
  runApp(const EmployeeApp());
}

class EmployeeApp extends StatelessWidget {
  const EmployeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => EmployeeCubit(db)..fetchEmployees()),
      ],
      child: MaterialApp(
        title: 'Employee Management',
        theme: AppTheme.lightTheme,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}