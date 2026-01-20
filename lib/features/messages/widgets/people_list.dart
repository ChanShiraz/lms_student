import 'package:flutter/material.dart';
import 'package:lms_student/common/summatives_shimmer.dart';
import 'package:lms_student/features/messages/models/people.dart';

class PeopleList extends StatelessWidget {
  final List<People> peoples;
  //final VoidCallback onBack;
  final ValueChanged<People> onSelect;
  final bool isLoading;
  //final int? selectedId;

  const PeopleList({
    super.key,
    required this.peoples,
    // required this.onBack,
    required this.onSelect,
    required this.isLoading,
    //required this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SummativesShimmer(
            padding: 0.5,
            borderRadius: 1,
            height: 40,
            quantity: 6,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ListTile(
              //   leading: IconButton(
              //     onPressed: onBack,
              //     icon: Icon(Icons.arrow_back),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Select a persone to start chat with',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: peoples.length,
                    itemBuilder: (_, i) {
                      final p = peoples[i];
                      return ListTile(
                        selectedColor: Colors.black,
                        selectedTileColor: Colors.grey.shade200,
                        //selected: selectedId != null && selectedId == p.userid,
                        //leading: CircleAvatar(child: Text(p.first[0])),
                        title: Text(
                          p.name,
                          style: const TextStyle(fontSize: 15),
                        ),
                        // subtitle: Text(
                        //   'student',
                        //   style: const TextStyle(
                        //     color: Colors.grey,
                        //     fontSize: 11,
                        //   ),
                        // ),
                        onTap: () => onSelect(p),
                      );
                    },
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, thickness: 0.3),
                  ),
                ),
              ),
            ],
          );
  }
}
