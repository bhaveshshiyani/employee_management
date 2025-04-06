import 'package:employee_management/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../bloc/employee_cubit.dart';
import '../../bloc/employee_state.dart';
import '../../data/database.dart';
import '../widgets/employee_tile.dart';
import 'employee_form_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          } else if (state is EmployeeLoaded) {
            final employees = state.employees;
            return Column(
              children: [
                Expanded(
                  child: StickyGroupedListView<EmployeeWithRole, String>(
                    elements: employees,
                    order: StickyGroupedListOrder.ASC,
                    groupBy: (employee) =>
                        (employee.employee.isCurrentlyWorking ||
                                employee.employee.toDate == null)
                            ? 'Current Employees'
                            : 'Previous Employees',
                    groupSeparatorBuilder: (EmployeeWithRole employee) {
                      final isCurrent = employee.employee.isCurrentlyWorking ||
                          employee.employee.toDate == null;
                      final groupTitle = isCurrent
                          ? 'Current Employees'
                          : 'Previous Employees';

                      return Container(
                        width: double.infinity,
                        color: AppTheme.backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            groupTitle,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryColor),
                          ),
                        ),
                      );
                    },
                    itemBuilder: (_, employee) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployeeFormPage(employee: employee),
                            ),
                          );
                        }, child: EmployeeTile(employee: employee)),
                    itemComparator: (a, b) =>
                        a.employee.fromDate.compareTo(b.employee.fromDate),
                    floatingHeader: true,
                    separator: const Divider(
                        height: 0.5, color: AppTheme.backgroundColor),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: AppTheme.backgroundColor,
                  height: 75,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 12),
                    child: Text(
                      "Swipe left to delete",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.hintColor),
                    ),
                  ),
                )
              ],
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
