import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/employee_cubit.dart';
import '../../bloc/employee_state.dart';
import '../widgets/employee_tile.dart';
import 'employee_form_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee List')),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/no_data.png',
                    width: 218,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'No employee records found',
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          } else if (state is EmployeeLoaded) {
            final employees = state.employees;
            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (_, index) =>
                  EmployeeTile(employee: employees[index]),
            );
          } else if (state is EmployeeError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EmployeeFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
