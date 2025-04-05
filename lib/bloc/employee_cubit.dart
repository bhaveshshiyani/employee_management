import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/database.dart';
import 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final AppDatabase db;

  EmployeeCubit(this.db) : super(EmployeeInitial());

  void fetchEmployees() async {
    emit(EmployeeLoading());
    try {
      final data = await db.getEmployeesWithRoles();
      if (data.isEmpty) {
        emit(EmployeeEmpty());
      } else {
        emit(EmployeeLoaded(data));
      }
    } catch (e) {
      emit(EmployeeError('Failed to load employees'));
    }
  }

  Future<void> addEmployee(EmployeesCompanion employee) async {
    await db.insertEmployee(employee);
    fetchEmployees();
  }

  Future<void> updateEmployee(int id, EmployeesCompanion employee) async {
    await db.updateEmployee(id, employee);
    fetchEmployees();
  }

  Future<void> deleteEmployee(int id) async {
    await db.deleteEmployee(id);
    fetchEmployees();
  }
}
