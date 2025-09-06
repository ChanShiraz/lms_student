import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms_student/features/courses/model/learning_journey.dart';
import 'package:lms_student/features/home/widgets/journey_widget.dart';
import 'package:lms_student/features/summatives/model/summative.dart';
import 'package:shimmer/shimmer.dart';

class SummativeWidget extends StatelessWidget {
  const SummativeWidget({super.key, required this.summative});
  final Summative summative;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: summative.image != null
            ? CachedNetworkImageProvider(summative.image!)
            : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              summative.title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Icon(icon(summative.status), color: statusColor(summative.status)),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Text('Grade : '), buildGradeWidget(summative.grade)]),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due Date: ${DateFormat('MM/dd/yyyy').format(summative.dueDate)}',
                style: TextStyle(
                  fontSize: 15,
                  color: statusColor(summative.status),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color statusColor(int status) {
    if (status == 2) {
      return Colors.orange;
    } else if (status == 1 || status == 0) {
      return Colors.green;
    } else if (status == 3) {
      return Colors.blue;
    } else if (status == 4) {
      return Colors.red;
    }
    return Colors.red;
  }

  IconData? icon(int status) {
    switch (status) {
      case 2:
        return Icons.warning_outlined;
      case 0:
        return Icons.hourglass_bottom_outlined;
      case 1:
        return Icons.done_rounded;
      case 3:
        return null;
      case 4:
        return Icons.warning_outlined;
    }
    return null;
  }
}

class SummativeShimmerWidget extends StatelessWidget {
  const SummativeShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: const CircleAvatar(radius: 24, backgroundColor: Colors.white),
      ),
      title: Row(
        children: [
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(height: 16, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(height: 20, width: 20, color: Colors.white),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(height: 14, width: 140, color: Colors.white),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(height: 14, width: 40, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget buildGradeWidget(double? grade) {
  print('Grade comes $grade');
  if (grade == null) {
    return Text('NO EVIDENCE');
  } else if (grade == -1) {
    return Text('NO EVIDENCE', style: TextStyle(color: Colors.red));
  } else if (grade < 0.5) {
    return Text('NO EVIDENCE', style: TextStyle(color: Colors.red));
  } else if (grade < 1.5) {
    return Text('EMERGING', style: TextStyle(color: Colors.orange));
  } else if (grade < 2.5) {
    return Text('CAPABLE', style: TextStyle(color: Colors.lightBlue));
  } else if (grade < 3.5) {
    return Text('BRIDGING', style: TextStyle(color: Colors.purple));
  } else if (grade < 4.5) {
    return Text('PROFICIENT', style: TextStyle(color: Colors.blue));
  } else if (grade <= 5) {
    return Text('METACOGNITION', style: TextStyle(color: Colors.blue));
  }
  return Text('NO EVIDENCE');
}
