import 'package:drift/drift.dart';
import 'package:employee_management/presentation/widgets/role_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/employee_cubit.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../model/employee_model.dart';
import '../widgets/custom_date_picker.dart';

class EmployeeFormPage extends StatefulWidget {
  final EmployeeWithRole? employee;

  const EmployeeFormPage({super.key, this.employee});

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  List<Role> _roles = [];
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
        if (widget.employee != null) {
          employeeModel.role = widget.employee?.role;
        }
      });
    });
  }

  void _delete() {
    context.read<EmployeeCubit>().deleteEmployee(employeeModel.id);
    Navigator.pop(context);
  }

  bool checkValidation() {
    if (employeeModel.name.trim().isEmpty) {
      showMessage("Please enter employee name.");
      return false;
    } else if ((employeeModel.role?.id ?? 0) <= 0) {
      showMessage("Please select employee role.");
      return false;
    } else if (employeeModel.fromDate == null) {
      showMessage("Please select employee joining date.");
      return false;
    } else {
      return true;
    }
  }

  showMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  void _save() {
    if (checkValidation()) {
      final emp = EmployeesCompanion(
        id: employeeModel.id < 0
            ? Value(employeeModel.id)
            : const Value.absent(),
        name: Value(employeeModel.name),
        roleId: Value(employeeModel.role?.id ?? 0),
        fromDate: Value(employeeModel.fromDate ?? DateTime.now()),
        toDate: Value(employeeModel.toDate),
        isCurrentlyWorking: Value(employeeModel.toDate == null ? true : false),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.employee == null
              ? 'Add Employee Details'
              : 'Edit Employee Details'),
          actions: [
            if (widget.employee != null)
              InkWell(
                onTap: _delete,
                child: Image.asset(
                  "assets/images/delete_icon.png",
                  width: 24,
                  height: 24,
                ),
              ),
            SizedBox(width: 16)
          ]),
      body: _roles.isEmpty
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
                          maxLength: 100,
                          textCapitalization: TextCapitalization.words,
                          controller:
                              TextEditingController(text: employeeModel.name),
                          decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Employee name',
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppTheme.hintColor),
                              border: InputBorder.none),
                          onChanged: (val) => employeeModel.name = val,
                        ),
                        false),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (context) => RoleSelection(
                            onRoleSelection: (role) {
                              setState(() {
                                employeeModel.role = role;
                              });
                            },
                            roles: _roles,
                          ),
                        );
                      },
                      child: commonDecoration(
                          "assets/images/role_icon.png",
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                                (employeeModel.role?.title ?? "").isNotEmpty
                                    ? (employeeModel.role?.title ?? "")
                                    : "Select role",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: (employeeModel.role?.title ?? "")
                                            .isNotEmpty
                                        ? AppTheme.textColor
                                        : AppTheme.hintColor)),
                          ),
                          true),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  insetPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  child: CustomDatePicker(
                                    isToDate: false,
                                    initialDate: DateTime.now(),
                                    onDateSelected: (pickedDate) {
                                      setState(() {
                                        employeeModel.fromDate = pickedDate;
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          child: commonDecoration(
                              "assets/images/date_icon.png",
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(employeeModel.getFromDate(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: AppTheme.textColor)),
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
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return Dialog(
                                    insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: CustomDatePicker(
                                      isToDate: true,
                                      initialDate:
                                          (employeeModel.fromDate != null)
                                              ? employeeModel.fromDate
                                              : DateTime.now(),
                                      onDateSelected: (pickedDate) {
                                        setState(() {
                                          employeeModel.toDate = pickedDate;
                                          employeeModel.isCurrentlyWorking =
                                              (employeeModel.toDate == null);
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: commonDecoration(
                                "assets/images/date_icon.png",
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(employeeModel.getToDate(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: (employeeModel.toDate != null)
                                              ? AppTheme.textColor
                                              : AppTheme.hintColor)),
                                ),
                                false),
                          ),
                        )
                      ],
                    ),
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.borderColor,
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
