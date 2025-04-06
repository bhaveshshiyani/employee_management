import 'package:employee_management/core/theme.dart';
import 'package:employee_management/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../bloc/employee_cubit.dart';
import '../../data/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart' as drift;

class EmployeeTile extends StatelessWidget {
  final EmployeeWithRole employee;

  const EmployeeTile({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(employee.employee.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          final deletedEmployee = employee;
          context
              .read<EmployeeCubit>()
              .deleteEmployee(deletedEmployee.employee.id);

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Employee data has been deleted',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.white),),
              action: SnackBarAction(
                label: 'Undo',
                textColor: AppTheme.primaryColor,
                backgroundColor: AppTheme.textColor,
                onPressed: () {
                  final emp = EmployeesCompanion(
                    id: drift.Value(deletedEmployee.employee.id),
                    name: drift.Value(deletedEmployee.employee.name),
                    roleId: drift.Value(deletedEmployee.role.id),
                    fromDate: drift.Value(deletedEmployee.employee.fromDate),
                    toDate: drift.Value(deletedEmployee.employee.toDate),
                    isCurrentlyWorking:
                    drift.Value(deletedEmployee.employee.isCurrentlyWorking),
                  );
                  context.read<EmployeeCubit>().addEmployee(emp);
                },
              ),
            ),
          );
        }),
        children: [
          CustomSlidableAction(
            onPressed: (_) {},
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            autoClose: false,
            child: Image.asset(
              "assets/images/delete_icon.png",
              width: 26,
              height: 24,
            ),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(employee.employee.name,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
              SizedBox(height: 6),
              Text(employee.role.title,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: AppTheme.hintColor)),
              SizedBox(height: 6),
              Text((employee.employee.isCurrentlyWorking && employee.employee.toDate==null)?"From ${UtilsHelper.formatDate(employee.employee.fromDate, "d MMM yyyy")}":"${UtilsHelper.formatDate(employee.employee.fromDate, "d MMM yyyy")} - ${UtilsHelper.formatDate((employee.employee.toDate??DateTime.now()), "d MMM yyyy")}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12,color: AppTheme.hintColor)),
            ],


          ),
        ),
      ),
    );
  }
}
