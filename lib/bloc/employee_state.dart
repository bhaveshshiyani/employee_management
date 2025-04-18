import '../data/database.dart';

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}
class EmployeeEmpty extends EmployeeState {}
class EmployeeLoaded extends EmployeeState {
  final List<EmployeeWithRole> employees;
  EmployeeLoaded(this.employees);
}

class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);
}