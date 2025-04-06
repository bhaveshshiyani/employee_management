import 'package:employee_management/core/utils.dart';

import '../data/database.dart';

class EmployeeModel {
  int id;
  String name;
  Role? role;
  DateTime? fromDate;
  DateTime? toDate;
  bool isCurrentlyWorking;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.role,
    required this.fromDate,
    required this.toDate,
    required this.isCurrentlyWorking,
  });

  factory EmployeeModel.blank() => EmployeeModel(
        id: 0,
        name: '',
        role: null,
        fromDate: DateTime.now(),
        toDate: null,
        isCurrentlyWorking: false,
      );

  factory EmployeeModel.fromEntity(Employee employee) => EmployeeModel(
        id: employee.id,
        name: employee.name,
        role: null,
        fromDate: employee.fromDate,
        toDate: employee.toDate,
        isCurrentlyWorking: employee.isCurrentlyWorking,
      );

  String getFromDate() {
    if (UtilsHelper.areDatesSame(fromDate ?? DateTime.now(), DateTime.now())) {
      return "Today";
    } else {
      return UtilsHelper.formatDate(fromDate ?? DateTime.now(), "d MMM yyyy");
    }
  }
  String getToDate() {
    if (toDate==null) {
      return "No date";
    } else {
      return UtilsHelper.formatDate(toDate ?? DateTime.now(), "d MMM yyyy");
    }
  }
}
