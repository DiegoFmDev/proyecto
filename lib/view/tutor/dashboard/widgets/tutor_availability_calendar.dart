import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_projects/styles/app_styles.dart';

class TutorAvailabilityCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<DateTime, List<Map<String, String>>> freeTimesByDay;
  final Function(DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;
  final Function(Map<String, String>) onDeleteSlot;
  final VoidCallback onAddSlot;

  const TutorAvailabilityCalendar({
    Key? key,
    required this.focusedDay,
    this.selectedDay,
    required this.freeTimesByDay,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onDeleteSlot,
    required this.onAddSlot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkBlue.withOpacity(0.8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.orangeprimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildCalendarGrid(context),
          if (selectedDay != null) ...[
            const SizedBox(height: 16),
            _buildSelectedDaySchedule(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Mi Calendario',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        ElevatedButton.icon(
          onPressed: onAddSlot,
          icon: const Icon(Icons.add, color: Colors.white, size: 16),
          label: const Text('Añadir', style: TextStyle(color: Colors.white, fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orangeprimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(focusedDay.year, focusedDay.month);
    final firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final weekDayOffset = firstDayOfMonth.weekday - 1;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () => onPageChanged(DateTime(focusedDay.year, focusedDay.month - 1, 1)),
            ),
            Text(
              DateFormat('MMMM yyyy', 'es').format(focusedDay).toUpperCase(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () => onPageChanged(DateTime(focusedDay.year, focusedDay.month + 1, 1)),
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: daysInMonth + weekDayOffset,
          itemBuilder: (context, i) {
            if (i < weekDayOffset) return const SizedBox.shrink();
            final day = DateTime(focusedDay.year, focusedDay.month, i - weekDayOffset + 1);
            final hasFreeTime = freeTimesByDay.keys.any((d) => DateUtils.isSameDay(d, day));
            final isSelected = selectedDay != null && DateUtils.isSameDay(selectedDay!, day);

            return GestureDetector(
              onTap: () => onDaySelected(day),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.orangeprimary.withOpacity(0.7) 
                      : (hasFreeTime ? AppColors.primaryGreen.withOpacity(0.4) : Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasFreeTime ? AppColors.primaryGreen : Colors.white24,
                    width: hasFreeTime ? 2 : 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    color: hasFreeTime || isSelected ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSelectedDaySchedule() {
    final times = freeTimesByDay.entries.firstWhere(
      (e) => DateUtils.isSameDay(e.key, selectedDay!),
      orElse: () => MapEntry(selectedDay!, []),
    ).value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (times.isEmpty)
            const Text('Sin horarios este día', style: TextStyle(color: Colors.white60))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: times.map((slot) => Chip(
                backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
                label: Text('${slot['start']} - ${slot['end']}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                onDeleted: () => onDeleteSlot(slot),
                deleteIconColor: Colors.redAccent,
              )).toList(),
            ),
        ],
      ),
    );
  }
}