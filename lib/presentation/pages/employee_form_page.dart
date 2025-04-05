import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/employee_cubit.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../model/employee_model.dart';
import '../widgets/date_picker.dart';

class EmployeeFormPage extends StatefulWidget {
  final EmployeeWithRole? employee;

  const EmployeeFormPage({super.key, this.employee});

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {

  late List<Role> _roles;
  EmployeeModel employeeModel = EmployeeModel.blank();
  @override
  void initState() {
    super.initState();
    final db = context.read<EmployeeCubit>().db;

    db.getAllRoles().then((roles) {
      setState(() {
        _roles = roles;
        employeeModel = widget.employee != null
            ? EmployeeModel.fromEntity(widget.employee!.employee)
            : EmployeeModel.blank();
        employeeModel.role ??= _roles.firstOrNull;
        
        // temp
        employeeModel.toDate = DateTime.now();
        employeeModel.fromDate =  DateTime(2020, 4, 5);
      });
    });
  }

  void _save() {

    final emp = EmployeesCompanion(
      id: employeeModel.id < 0
          ? Value(employeeModel.id)
          : const Value.absent(),
      name: Value(employeeModel.name),
      roleId: Value(employeeModel.role?.id??0),
      fromDate: Value(employeeModel.fromDate??DateTime.now()),
      toDate: Value(employeeModel.toDate),
      isCurrentlyWorking: Value(employeeModel.fromDate==null?true:false),
    );
    if (widget.employee == null) {
      context.read<EmployeeCubit>().addEmployee(emp);
    } else {
      context
          .read<EmployeeCubit>()
          .updateEmployee(widget.employee!.employee.id, emp);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Container(),
          title: Text(widget.employee == null
              ? 'Add Employee Details'
              : 'Edit Employee Details')),
      body: _roles == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, top: 24, right: 16, bottom: 24),
                child: ListView(
                  children: [
                    commonDecoration(
                        "assets/images/emp_name_icon.png",
                        TextFormField(
                          controller: TextEditingController(text: employeeModel.name),
                          decoration: const InputDecoration(
                              hintText: 'Employee name',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppTheme.hintColor),
                              border: InputBorder.none),
                          onChanged: (val) => employeeModel.name = val,
                        ),
                        false),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {},
                      child: commonDecoration(
                          "assets/images/role_icon.png",
                          TextFormField(
                            controller: TextEditingController(text: employeeModel.role?.title??""),
                            readOnly: true,
                            decoration: const InputDecoration(
                                hintText: 'Select role',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: AppTheme.hintColor),
                                border: InputBorder.none),
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Select role'
                                    : null,
                          ),
                          true),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {},
                          child: commonDecoration(
                              "assets/images/date_icon.png",
                              TextFormField(
                                controller: TextEditingController(text: employeeModel.fromDate.toString()??""),
                                readOnly: true,
                                decoration: const InputDecoration(
                                    hintText: 'From date',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: AppTheme.hintColor),
                                    border: InputBorder.none),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'From date'
                                        : null,
                              ),
                              false),
                        )),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Image.asset(
                            "assets/images/arrow_right.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: commonDecoration(
                                "assets/images/date_icon.png",
                                TextFormField(
                                  controller: TextEditingController(text: employeeModel.toDate.toString()??""),
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                      hintText: 'No date',
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: AppTheme.hintColor),
                                      border: InputBorder.none),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'No date'
                                          : null,
                                ),
                                false),
                          ),
                        )
                      ],
                    ),

                    /*   ElevatedButton(
                      onPressed: _save,
                      child: const Text('Save'),
                    )*/
                  ],
                ),
              ),
            ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cancelButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    fixedSize: Size(100, 48),
                    elevation: 0,
                  ),
                  onPressed: _save,
                  child: const Text('Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppTheme.primaryColor)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    fixedSize: Size(100, 48),
                    elevation: 0,
                  ),
                  onPressed: _save,
                  child: const Text('Save',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget commonDecoration(String img, Widget widget, bool isDropDown) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4), // Rounded corners
        border: Border.all(
          color: AppTheme.borderColor, // Border color
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Image.asset(
              img,
              width: 24,
              height: 24,
            ),
          ),
          // TextField with flexible width
          Expanded(
            child: widget,
          ),
          if (isDropDown)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                "assets/images/dropdown_arrow.png",
                width: 20,
                height: 20,
              ),
            ),
        ],
      ),
    );
  }
}
