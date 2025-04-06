import 'package:employee_management/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final bool? isToDate;
  final void Function(DateTime?) onDateSelected;

  const CustomDatePicker({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    this.isToDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? selectedDate;
  DateTime? minSelectableDate;
  bool isToDate = false;
  DateTime? focusedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    isToDate = widget.isToDate ?? false;
    focusedDate = selectedDate ?? DateTime.now();

    if (isToDate) {
      minSelectableDate = widget.initialDate;
    }else{
      minSelectableDate = DateTime(2000,1);
    }
  }

  DateTime _nextWeekday(int weekday) {
    final now = DateTime.now();
    final daysToAdd = (weekday - now.weekday + 7) % 7;
    return now.add(Duration(days: daysToAdd == 0 ? 7 : daysToAdd));
  }

  Widget _buildQuickButton(String label, DateTime? value) {
    final isSelected = selectedDate?.toString().substring(0, 10) ==
        value?.toString().substring(0, 10);
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor:
                isSelected ? AppTheme.primaryColor : AppTheme.cancelButtonColor,
            foregroundColor: isSelected ? Colors.white : AppTheme.primaryColor,
            side: BorderSide.none,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            fixedSize: Size(0, 36)),
        onPressed: () => setState(() => selectedDate = value),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
        ),
      ),
    );
  }
  bool previousButtonEnable() {
    if (isToDate) {
      final focus = focusedDate ?? DateTime.now();
      final prevMonthDate = DateTime(focus.year, focus.month - 1);
      final minMonth = DateTime(minSelectableDate!.year, minSelectableDate!.month);

      return !prevMonthDate.isBefore(minMonth);
    }
    return true;
  }
  void _onPreviousMonth() {
    final prevMonth = DateTime((selectedDate??DateTime.now()).year, (selectedDate??DateTime.now()).month - 1);
    final minMonth = DateTime(minSelectableDate!.year, minSelectableDate!.month);

    if (!prevMonth.isBefore(minMonth)) {
      setState(() {
        selectedDate = prevMonth;
        focusedDate = prevMonth;
      });
    }

  }


  void _onNextMonth() {
    final base = focusedDate ?? DateTime.now();
    final newDate = DateTime(base.year, base.month + 1);
    setState(() {
      focusedDate = newDate;
      selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime validFocusedDay = (focusedDate != null && focusedDate!.isAfter(minSelectableDate!))
        ? focusedDate!
        : minSelectableDate!;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(isToDate)...[
                  _buildQuickButton("No Date", null),
                  const SizedBox(width: 16),
                ],
                _buildQuickButton("Today", DateTime.now()),
                if(!isToDate)...[
                  const SizedBox(width: 16),
                  _buildQuickButton("Next Monday", _nextWeekday(1)),
                ]

              ],
            ),
          ),
          if(!isToDate)...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickButton("Next Tuesday", _nextWeekday(2)),
                  const SizedBox(width: 16),
                  _buildQuickButton("After 1 week",
                      DateTime.now().add(const Duration(days: 7))),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if (previousButtonEnable()) {
                    _onPreviousMonth();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Image.asset(
                    (previousButtonEnable())
                        ? "assets/images/prev_icon.png"
                        : "assets/images/prev_icon_disable.png",
                    width: 18,
                    height: 12,
                    colorBlendMode: BlendMode.colorBurn,
                  ),
                ),
              ),
              Text(
                DateFormat.yMMMM().format(selectedDate ?? DateTime.now()),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              InkWell(
                onTap: () {
                  _onNextMonth();
                },
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Image.asset(
                    "assets/images/next_icon.png",
                    width: 18,
                    height: 12,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
            child: TableCalendar(
              firstDay: minSelectableDate!,
              focusedDay: validFocusedDay,
              selectedDayPredicate: (day) => selectedDate != null && isSameDay(selectedDate, day),
              onDaySelected: (selected, focused) {

                if (!selected.isBefore(minSelectableDate!)) {
                  setState(() {
                    selectedDate = selected;
                  });
                }
              },
              lastDay: DateTime(2100),
              onPageChanged: (focusedDay) {
                setState(() {
                  focusedDate = focusedDay;
                });
              },
              headerVisible: false,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                selectedDecoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: Colors.white,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryColor,
                    width: 1.5,
                  ),
                ),
                todayTextStyle: TextStyle(
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          const Divider(thickness: 1, color: AppTheme.backgroundColor),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  "assets/images/date_icon.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  selectedDate != null
                      ? DateFormat('d MMM yyyy').format(selectedDate!)
                      : 'No date',

                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: AppTheme.cancelButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    fixedSize: Size(73, 40),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppTheme.primaryColor)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    fixedSize: Size(73, 40),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onDateSelected(selectedDate);
                  },
                  child: const Text('Save',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
