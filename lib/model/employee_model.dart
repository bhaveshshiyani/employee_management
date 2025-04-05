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
        fromDate: null,
        toDate: null,
        isCurrentlyWorking: false,
      );

  factory EmployeeModel.fromEntity(Employee employee) => EmployeeModel(
        id: employee.id,
        name: employee.name,
        role: null,
        // will assign via `initState`
        fromDate: employee.fromDate,
        toDate: employee.toDate,
        isCurrentlyWorking: employee.isCurrentlyWorking,
      );

}
