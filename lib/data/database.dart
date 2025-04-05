import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Roles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 50)();
}

class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get roleId => integer().references(Roles, #id)();
  DateTimeColumn get fromDate => dateTime()();
  DateTimeColumn get toDate => dateTime().nullable()();
  BoolColumn get isCurrentlyWorking => boolean().withDefault(Constant(false))();
}

@DriftDatabase(tables: [Roles, Employees])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();

      await batch((batch) {
        batch.insertAll(roles, [
          RolesCompanion.insert(title: 'Product Designer'),
          RolesCompanion.insert(title: 'Flutter Developer'),
          RolesCompanion.insert(title: 'QA Tester'),
          RolesCompanion.insert(title: 'Product Owner'),
        ]);
      });
    },
  );
  Future<List<Role>> getAllRoles() => select(roles).get();

  // Employee CRUD
  Future<int> insertEmployee(EmployeesCompanion employee) => into(employees).insert(employee);

  Future<int> updateEmployee(int id, EmployeesCompanion employee) =>
      (update(employees)..where((tbl) => tbl.id.equals(id))).write(employee);

  Future<int> deleteEmployee(int id) =>
      (delete(employees)..where((tbl) => tbl.id.equals(id))).go();

  Future<List<EmployeeWithRole>> getEmployeesWithRoles() async {
    final query = select(employees).join([
      innerJoin(roles, roles.id.equalsExp(employees.roleId)),
    ]);

    return query.map((row) {
      return EmployeeWithRole(
        employee: row.readTable(employees),
        role: row.readTable(roles),
      );
    }).get();
  }
}


class EmployeeWithRole {
  final Employee employee;
  final Role role;

  EmployeeWithRole({required this.employee, required this.role});
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'employee.db'));
    return NativeDatabase(file);
  });
}
