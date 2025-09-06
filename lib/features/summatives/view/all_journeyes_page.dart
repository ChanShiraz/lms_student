import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/summatives/widgets/summative_widget.dart';

class AllJourneyesPage extends StatelessWidget {
  const AllJourneyesPage({super.key, required this.journeyes});
  final List<Journey> journeyes;
  static final routeName = '/AllJourneyesPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Learning Journeyes')),
      body: ListView.builder(
        itemCount: journeyes.length,
        itemBuilder: (context, index) =>
            AllJourneyWidget(journey: journeyes[index]),
      ),
    );
  }
}

class AllJourneyWidget extends StatelessWidget {
  const AllJourneyWidget({super.key, required this.journey});
  final Journey journey;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: journey.imageLink != null
            ? CachedNetworkImageProvider(journey.imageLink!)
            : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              journey.title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          Icon(icon(journey.status), color: statusColor(journey.status)),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Text('Grade : '), buildGradeWidget(journey.grade)]),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due Date: ${DateFormat('MM/dd/yyyy').format(journey.dueDate)}',
                style: TextStyle(
                  fontSize: 15,
                  color: statusColor(journey.status),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color statusColor(int? status) {
    if (status == null) {
      return Colors.blue;
    } else if (status == 2) {
      return Colors.orange;
    } else if (status == 1 || status == 0) {
      return Colors.green;
    } else if (status == 3) {
      return Colors.red;
    } else if (status == 4) {
      return Colors.red;
    }
    return Colors.red;
  }

  IconData? icon(int? status) {
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
