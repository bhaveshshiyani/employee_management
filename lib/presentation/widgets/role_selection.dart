import 'package:employee_management/core/theme.dart';
import 'package:flutter/material.dart';

import '../../data/database.dart';

class RoleSelection extends StatelessWidget {
  final void Function(Role?) onRoleSelection;
  final List<Role> roles;

  const RoleSelection({
    super.key,
    required this.onRoleSelection,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        itemCount: roles.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 52,
            child: ListTile(
              onTap: () {
                onRoleSelection(roles[index]);
                Navigator.pop(context);
              },
              title: Center(
                child: Text(roles[index].title,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(thickness: 1, color: AppTheme.backgroundColor);
        },
      ),
    );
  }
}
