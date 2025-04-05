import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final String label;
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePicker({
    super.key,
    required this.label,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = initialDate != null
        ? "${initialDate!.day}/${initialDate!.month}/${initialDate!.year}"
        : 'Select date';

    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate ?? now,
          firstDate: DateTime(1950),
          lastDate: DateTime(2100),
        );
        if (picked != null) onDateSelected(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(formattedDate),
      ),
    );
  }
}
