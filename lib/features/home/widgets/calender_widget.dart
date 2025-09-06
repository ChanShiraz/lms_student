import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/home/widgets/journey_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomWeekCalendar extends StatelessWidget {
  const CustomWeekCalendar({
    super.key,
    required this.homeController,
    required this.currentDayColor,
  });
  final Color? currentDayColor;
  final HomeController homeController;
  @override
  Widget build(BuildContext context) {
    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;
    return TableCalendar(
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.now().add(const Duration(days: 30)),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.week,
      availableCalendarFormats: const {CalendarFormat.week: 'Week'},
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.red),
        weekdayStyle: TextStyle(color: Colors.blue),
      ),
      headerStyle: const HeaderStyle(
        leftChevronVisible: false,
        rightChevronVisible: false,
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      calendarStyle: CalendarStyle(
        weekendTextStyle: TextStyle(color: Colors.red),
        defaultTextStyle: TextStyle(color: Colors.blue),
        todayDecoration: BoxDecoration(
          color: currentDayColor,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        holidayTextStyle: TextStyle(color: Colors.blue),
      ),
      onDaySelected: (selectedDay, focusedDay) {},
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          return Obx(() {
            if (homeController.isLoadingJourneys.value) {
              return const SizedBox();
            }

            if (homeController.journies.isEmpty) {
              return const SizedBox();
            }

            final extractedDates = homeController.journies.map((journey) {
              final DateTime selectedDate =
                  journey.completedDate ?? journey.dueDate;
              return {'date': selectedDate, 'status': journey.status};
            }).toList();

            int completedCount = 0;
            int assignedCount = 0;
            int resubmitCount = 0;
            int pastDueCount = 0;

            // --- Normal per-day counting ---
            for (var date in extractedDates) {
              final d = date['date'] as DateTime;
              if (d.year == day.year &&
                  d.month == day.month &&
                  d.day == day.day) {
                final status = date['status'];
                if (status == null) {
                  assignedCount++;
                } else if (status == 1 || status == 0) {
                  completedCount++;
                } else if (status == 2) {
                  resubmitCount++;
                } else if (status == 3) {
                  pastDueCount++;
                }
              }
            }

            // --- Additional overdue reminder ONLY for resubmit/past due ---
            if (isSameDay(day, DateTime.now())) {
              for (var date in extractedDates) {
                final d = date['date'] as DateTime;
                if (d.isBefore(DateTime.now()) &&
                    !(d.year == day.year &&
                        d.month == day.month &&
                        d.day == day.day)) {
                  final status = date['status'];
                  if (status == 2) {
                    resubmitCount++;
                  } else if (status == 3) {
                    pastDueCount++;
                  }
                }
              }
            }

            if (completedCount > 0 ||
                assignedCount > 0 ||
                resubmitCount > 0 ||
                pastDueCount > 0) {
              return _buildBubble(
                completedCount: completedCount,
                assignedCount: assignedCount,
                resubmitCount: resubmitCount,
                pastDueCount: pastDueCount,
              );
            }

            return const SizedBox();
          });
        },
      ),

      // calendarBuilders: CalendarBuilders(
      //   markerBuilder: (context, day, events) {
      //     return Obx(() {
      //       if (homeController.isLoadingJourneys.value) {
      //         return SizedBox();
      //       } else if (!homeController.isLoadingJourneys.value &&
      //           homeController.journies.isNotEmpty) {
      //         final extractedDates = homeController.journies.map((journey) {
      //           final DateTime selectedDate =
      //               journey.completedDate ?? journey.dueDate;
      //           return {'date': selectedDate, 'status': journey.status};
      //         }).toList();
      //         int completedCount = 0;
      //         int assignedCount = 0;
      //         int resubmitCount = 0;
      //         int pastDueCount = 0;

      //         for (var date in extractedDates) {
      //           final d = date['date'] as DateTime;
      //           if (d.year == day.year &&
      //               d.month == day.month &&
      //               d.day == day.day) {
      //             final status = date['status'];
      //             if (status == null) {
      //               assignedCount++;
      //             } else if (status == 1 || status == 0) {
      //               completedCount++;
      //             } else if (status == 2) {
      //               resubmitCount++;
      //             } else if (status == 3) {
      //               pastDueCount++;
      //             }
      //           }
      //         }

      //         if (completedCount > 0 ||
      //             assignedCount > 0 ||
      //             resubmitCount > 0 ||
      //             pastDueCount > 0) {
      //           return _buildBubble(
      //             completedCount: completedCount,
      //             assignedCount: assignedCount,
      //             resubmitCount: resubmitCount,
      //             pastDueCount: pastDueCount,
      //           );
      //         }

      //         return SizedBox();
      //       }
      //       return SizedBox();
      //     });
      //   },
      // ),
    );
  }

  Widget _buildBubble({
    required int completedCount,
    required int assignedCount,
    required int resubmitCount,
    required int pastDueCount,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        completedCount > 0
            ? CountWidget(color: Colors.green, count: completedCount)
            : SizedBox(),
        assignedCount > 0
            ? CountWidget(color: Colors.blue, count: assignedCount)
            : SizedBox(),
        pastDueCount > 0
            ? CountWidget(color: Colors.red, count: pastDueCount)
            : SizedBox(),
        resubmitCount > 0
            ? CountWidget(color: Colors.orange, count: resubmitCount)
            : SizedBox(),
      ],
    );
  }
}

class CountWidget extends StatelessWidget {
  const CountWidget({super.key, required this.color, required this.count});
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 17,
      height: 17,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: BoxBorder.all(color: Colors.white),
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }
}


 // final status = extractedDates.firstWhere((entry) {
                //   final d = entry['date'] as DateTime;
                //   return d.year == day.year &&
                //       d.month == day.month &&
                //       d.day == day.day;
                // })['status'];
                // return Positioned(
                //   bottom: 0,
                //   child: _buildBubble(status as int),
                // );