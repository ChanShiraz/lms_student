import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/home/models/learning_journey.dart';
import 'package:shimmer/shimmer.dart';

class JourneyWidget extends StatelessWidget {
  const JourneyWidget({super.key, required this.journey, required this.onTap});
  final Journey journey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(5),
              ),
              child: journey.imageLink != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: journey.imageLink!,
                        height: 40,
                        width: 40,
                        errorWidget: (context, url, error) =>
                            Icon(Icons.broken_image),
                      ),
                    )
                  : SizedBox(),
            ),

            SizedBox(height: 5),
            Text(
              journey.courseTitle,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            Text(
              DateFormat('MM/dd/yyyy').format(journey.dueDate),
              style: TextStyle(
                fontSize: 12,
                color: journey.status != null
                    ? dateColor(journey.status!)
                    : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color dateColor(int status) {
  switch (status) {
    case 0:
      return Colors.blue;
    case 1:
      return Colors.green;
    case 2:
      return Colors.orange;
    case 3:
      return Colors.red;
    default:
      return Colors.red;
  }
}

class JourneyWidgetShimmer extends StatelessWidget {
  const JourneyWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black12),
              ),
            ),
            const SizedBox(height: 5),
            Container(height: 12, width: 60, color: Colors.white),
            const SizedBox(height: 5),
            Container(height: 12, width: 50, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
