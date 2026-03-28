import 'package:flutter/material.dart';

class DateFilter extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;

  const DateFilter({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _pickDate(context),
      child: Text(
        selectedDate == null
            ? 'Select Date'
            : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
      ),
    );
  }
}
