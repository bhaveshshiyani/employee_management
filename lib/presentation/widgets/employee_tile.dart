import 'package:flutter/material.dart';
import '../../bloc/employee_cubit.dart';
import '../../data/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/employee_form_page.dart';

class EmployeeTile extends StatelessWidget {
  final EmployeeWithRole employee;
  const EmployeeTile({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(employee.employee.name),
      subtitle: Text(employee.role.title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EmployeeFormPage(employee: employee),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<EmployeeCubit>().deleteEmployee(employee.employee.id);
            },
          ),
        ],
      ),
    );
  }
}
